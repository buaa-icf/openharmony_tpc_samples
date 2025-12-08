/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/******************************************************************************
 * Spine Harmony Runtime - spine-c 扩展实现
 * 实现 _spAtlasPage_createTexture 等必需函数
 *****************************************************************************/

#include "spine_harmony.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <EGL/egl.h>
#include <GLES3/gl3.h>
#include <rawfile/raw_file_manager.h>
#include <hilog/log.h>

#define LOG_TAG "SpineHarmony"
#define LOGI(...) OH_LOG_INFO(LOG_APP, __VA_ARGS__)
#define LOGE(...) OH_LOG_ERROR(LOG_APP, __VA_ARGS__)

// ============================================================================
// 全局资源管理器
// ============================================================================

static NativeResourceManager* g_resourceManager = nullptr;

void SpineSetResourceManager(void* resMgr)
{
    g_resourceManager = static_cast<NativeResourceManager*>(resMgr);
    LOGI("Resource manager set: %p", g_resourceManager);
}

// ============================================================================
// STB Image 实现（用于加载 PNG/JPG 纹理）
// ============================================================================

#define STB_IMAGE_IMPLEMENTATION
#define STBI_NO_STDIO
#define STBI_ONLY_PNG
#define STBI_ONLY_JPEG
#include "thirdparty/stb/stb_image.h"

// ============================================================================
// 文件读取实现
// ============================================================================

char* SpineReadRawfile(const char* path, int* length)
{
    if (!g_resourceManager) {
        LOGE("Resource manager not set!");
        return nullptr;
    }
    
    RawFile* rawFile = OH_ResourceManager_OpenRawFile(g_resourceManager, path);
    if (!rawFile) {
        LOGE("Failed to open rawfile: %s", path);
        return nullptr;
    }
    
    long size = OH_ResourceManager_GetRawFileSize(rawFile);
    if (size <= 0) {
        LOGE("Invalid rawfile size: %ld", size);
        OH_ResourceManager_CloseRawFile(rawFile);
        return nullptr;
    }
    
    char* data = (char*)malloc(size + 1);
    if (!data) {
        LOGE("Failed to allocate memory for rawfile");
        OH_ResourceManager_CloseRawFile(rawFile);
        return nullptr;
    }
    
    int readSize = OH_ResourceManager_ReadRawFile(rawFile, data, size);
    OH_ResourceManager_CloseRawFile(rawFile);
    
    if (readSize != size) {
        LOGE("Failed to read rawfile completely: %d / %ld", readSize, size);
        free(data);
        return nullptr;
    }
    
    data[size] = '\0';
    *length = static_cast<int>(size);
    
    LOGI("Read rawfile: %s, size: %d", path, *length);
    return data;
}

// ============================================================================
// spine-c 扩展函数实现
// ============================================================================

// 读取文件（spine-c 要求实现）
extern "C" char* _spUtil_readFile(const char* path, int* length)
{
    // 首先尝试从 rawfile 读取
    char* data = SpineReadRawfile(path, length);
    if (data) {
        return data;
    }
    
    // 回退到标准文件读取
    FILE* file = fopen(path, "rb");
    if (!file) {
        LOGE("Failed to open file: %s", path);
        return nullptr;
    }
    
    int fseeknumber = fseek(file, 0, SEEK_END);
    if (fseeknumber != 0) {
        LOGE("fseek Failed");
    }
    *length = static_cast<int>(ftell(file));
    fseeknumber = fseek(file, 0, SEEK_SET);
    if (fseeknumber != 0) {
        LOGE("fseek Failed");
    }
    data = (char*)malloc(*length + 1);
    if (!data) {
        int result = fclose(file);
        if (result != 0) {
            LOGI("fclose failed");
        }
        return nullptr;
    }
    
    size_t bytesRead = fread(data, 1, *length, file);
    LOGI("Failed to open file: %d", bytesRead);
    data[*length] = '\0';
    int result = fclose(file);
    if (result != 0) {
        LOGI("fclose failed");
    }
    
    return data;
}

static void StoreTextureResult(spAtlasPage* self, SpineTexture* texture, int width, int height, const char* path)
{
    self->rendererObject = texture;
    self->width = width;
    self->height = height;
    
    LOGI("Texture created: %s (%dx%d), id=%u", path, width, height, texture->id);
}

static bool NeedMipmap(GLenum minFilter)
{
    return (minFilter == GL_LINEAR_MIPMAP_LINEAR || minFilter == GL_LINEAR_MIPMAP_NEAREST ||
            minFilter == GL_NEAREST_MIPMAP_LINEAR || minFilter == GL_NEAREST_MIPMAP_NEAREST);
}

static GLenum GetGLWrapMode(spAtlasWrap wrap)
{
    if (wrap == SP_ATLAS_REPEAT) {
        return GL_REPEAT;
    }
    return GL_CLAMP_TO_EDGE;
}

static GLenum GetGLMagFilter(spAtlasFilter filter)
{
    switch (filter) {
        case SP_ATLAS_NEAREST:
            return GL_NEAREST;
        case SP_ATLAS_LINEAR:
        default:
            return GL_LINEAR;
    }
}

static GLenum GetGLMinFilter(spAtlasFilter filter)
{
    switch (filter) {
        case SP_ATLAS_NEAREST:
            return GL_NEAREST;
        case SP_ATLAS_LINEAR:
            return GL_LINEAR;
        case SP_ATLAS_MIPMAP:
        case SP_ATLAS_MIPMAP_LINEAR_LINEAR:
            return GL_LINEAR_MIPMAP_LINEAR;
        case SP_ATLAS_MIPMAP_LINEAR_NEAREST:
            return GL_LINEAR_MIPMAP_NEAREST;
        case SP_ATLAS_MIPMAP_NEAREST_LINEAR:
            return GL_NEAREST_MIPMAP_LINEAR;
        case SP_ATLAS_MIPMAP_NEAREST_NEAREST:
            return GL_NEAREST_MIPMAP_NEAREST;
        default:
            return GL_LINEAR;
    }
}

static void SetupTextureParameters(spAtlasPage* self, GLuint textureId,
                                   unsigned char* pixels, int width, int height)
{
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    // 设置过滤模式
    GLenum minFilter = GetGLMinFilter(self->minFilter);
    GLenum magFilter = GetGLMagFilter(self->magFilter);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
    
    // 设置包裹模式
    GLenum uWrap = GetGLWrapMode(self->uWrap);
    GLenum vWrap = GetGLWrapMode(self->vWrap);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, uWrap);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, vWrap);
    
    // 上传纹理数据
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    // 生成mipmap（如果需要）
    if (NeedMipmap(minFilter)) {
        glGenerateMipmap(GL_TEXTURE_2D);
    }
}

static GLuint GenerateGLTexture()
{
    GLuint textureId = 0;
    glGenTextures(1, &textureId);
    
    GLenum glError = glGetError();
    if (glError != GL_NO_ERROR) {
        LOGE("glGenTextures error: 0x%x", glError);
    }
    
    return textureId;
}

static SpineTexture* CreateSpineTexture(int width, int height)
{
    SpineTexture* texture = (SpineTexture*)malloc(sizeof(SpineTexture));
    if (!texture) {
        LOGE("Failed to allocate memory for SpineTexture");
        return nullptr;
    }
    
    texture->width = width;
    texture->height = height;
    
    return texture;
}

static void CreateGLTexture(spAtlasPage* self, const char* path,
                            unsigned char* pixels, int width, int height)
{
    // 创建纹理对象
    SpineTexture* texture = CreateSpineTexture(width, height);
    if (!texture) {
        stbi_image_free(pixels);
        return;
    }
    
    // 生成OpenGL纹理
    GLuint textureId = GenerateGLTexture();
    texture->id = textureId;
    
    // 绑定纹理并设置参数
    SetupTextureParameters(self, textureId, pixels, width, height);
    
    // 清理像素数据
    stbi_image_free(pixels);
    
    // 存储结果
    StoreTextureResult(self, texture, width, height, path);
}

static void HandleNoGLContext(spAtlasPage* self, unsigned char* pixels, int width, int height)
{
    LOGE("No EGL context! Cannot create OpenGL texture.");
    LOGE("Texture creation will be deferred.");
    
    stbi_image_free(pixels);
    
    self->rendererObject = nullptr;
    self->width = width;
    self->height = height;
}

static bool CheckGLContext()
{
    EGLContext currentContext = eglGetCurrentContext();
    return (currentContext != EGL_NO_CONTEXT);
}

static void HandleDecodeFailure(spAtlasPage* self)
{
    self->rendererObject = nullptr;
    self->width = 0;
    self->height = 0;
}

static unsigned char* DecodeImageData(unsigned char* data, int length, int* outWidth, int* outHeight, const char* path)
{
    LOGI("Decoding image with stb_image...");
    
    int channels = 0;
    unsigned char* pixels = stbi_load_from_memory(
        data, length, outWidth, outHeight, &channels, 4);
    if (!pixels) {
        LOGE("Failed to decode texture: %s, stbi_error: %s", path, stbi_failure_reason());
        return nullptr;
    }
    LOGI("Image decoded: %dx%d, channels: %d", *outWidth, *outHeight, channels);
    return pixels;
}

static void ProcessTextureData(spAtlasPage* self, const char* path, unsigned char* data, int length)
{
    // 解码图片
    unsigned char* pixels = nullptr;
    int width = 0;
    int height = 0;
    pixels = DecodeImageData(data, length, &width, &height, path);
    free(data);
    if (!pixels) {
        HandleDecodeFailure(self);
        return;
    }
    // 检查OpenGL上下文
    if (!CheckGLContext()) {
        HandleNoGLContext(self, pixels, width, height);
        return;
    }
    CreateGLTexture(self, path, pixels, width, height);
}

static void HandleTextureLoadFailure(spAtlasPage* self, const char* path)
{
    LOGE("Failed to load texture file: %s", path);
    
    // 设置默认值避免崩溃
    self->rendererObject = nullptr;
    self->width = 0;
    self->height = 0;
}

static unsigned char* LoadTextureFromFile(const char* path, int* outLength)
{
    FILE* file = fopen(path, "rb");
    if (!file) {
        LOGE("Failed to open file: %s", path);
        return nullptr;
    }
    
    // 获取文件大小
    int fseeknumber = fseek(file, 0, SEEK_END);
    if (fseeknumber != 0) {
        LOGE("fseek Failed");
    }
    long fileSize = ftell(file);
    fseeknumber = fseek(file, 0, SEEK_SET);
    if (fseeknumber != 0) {
        LOGE("fseek Failed");
    }
    
    if (fileSize <= 0) {
        LOGE("Invalid file size: %ld", fileSize);
        int result = fclose(file);
        if (result != 0) {
            LOGI("fclose failed");
        }
        return nullptr;
    }
    *outLength = static_cast<int>(fileSize);
    // 分配内存
    unsigned char* data = reinterpret_cast<unsigned char*>(malloc(*outLength));
    if (!data) {
        LOGE("Failed to allocate memory length: %d", *outLength);
        int result = fclose(file);
        if (result != 0) {
            LOGI("fclose failed");
        }
        return nullptr;
    }
    // 读取数据
    size_t readSize = fread(data, 1, *outLength, file);
    int result = fclose(file);
    if (result != 0) {
        LOGI("fclose failed");
    }
    if (readSize != *outLength) {
        LOGE("File read incomplete: %zu/%d", readSize, *outLength);
        free(data);
        return nullptr;
    }
    LOGI("File read success, length: %d", *outLength);
    return data;
}

static unsigned char* LoadTextureData(const char* path, int* outLength)
{
    *outLength = 0;
    // 先尝试 SpineReadRawfile
    unsigned char* data = (unsigned char*)SpineReadRawfile(path, outLength);
    if (data) {
        LOGI("Rawfile read success, length: %d", *outLength);
        return data;
    }
    LOGE("Failed to read texture from rawfile: %s", path);
    LOGI("Trying standard file read...");
    // 尝试标准文件读取
    return LoadTextureFromFile(path, outLength);
}

// 创建纹理（spine-c 要求实现）
extern "C" void _spAtlasPage_createTexture(spAtlasPage* self, const char* path)
{
    unsigned char* data = nullptr;
    int length = 0;
    data = LoadTextureData(path, &length);
    if (!data) {
        HandleTextureLoadFailure(self, path);
        return;
    }
    ProcessTextureData(self, path, data, length);
}

// 释放纹理（spine-c 要求实现）
extern "C" void _spAtlasPage_disposeTexture(spAtlasPage* self)
{
    if (self->rendererObject) {
        SpineTexture* texture = (SpineTexture*)self->rendererObject;
        glDeleteTextures(1, &texture->id);
        free(texture);
        self->rendererObject = nullptr;
        LOGI("Texture disposed");
    }
}
