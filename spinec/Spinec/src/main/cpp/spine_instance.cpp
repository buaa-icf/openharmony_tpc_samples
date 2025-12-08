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
 * Spine Harmony Runtime - Spine 实例和 EGL 上下文管理
 *****************************************************************************/

#include "spine_harmony.h"
#include <cstring>
#include <hilog/log.h>
#include "securec.h"

#define LOG_TAG "SpineInstance"
#define LOGI(...) OH_LOG_INFO(LOG_APP, __VA_ARGS__)
#define LOGE(...) OH_LOG_ERROR(LOG_APP, __VA_ARGS__)

// 辅助函数：获取目录路径
static char* GetDirectory(const char* path)
{
    const char* lastSlash = strrchr(path, '/');
    if (!lastSlash) {
        // 没有斜杠，返回空字符串
        char* dir = (char*)malloc(1);
        dir[0] = '\0';
        return dir;
    }
    
    int len = lastSlash - path;
    char* dir = (char*)malloc(len + 1);
    memcpy_s(dir, sizeof(dir), path, len);
    dir[len] = '\0';
    return dir;
}

// ============================================================================
// Spine 实例管理
// ============================================================================

// 1. 读取Atlas数据
static spAtlas* LoadAtlasData(const char* atlasPath)
{
    int atlasLength = 0;
    char* atlasData = SpineReadRawfile(atlasPath, &atlasLength);
    if (!atlasData) {
        LOGE("Failed to read atlas file from rawfile: %s", atlasPath);
        return nullptr;
    }
    LOGI("Atlas data loaded, length: %d", atlasLength);
    
    // 获取 atlas 目录路径
    char* atlasDir = GetDirectory(atlasPath);
    LOGI("Atlas directory: '%s'", atlasDir);
    // 创建 Atlas（使用内存数据）
    spAtlas* atlas = spAtlas_create(atlasData, atlasLength, atlasDir, nullptr);
    free(atlasData);
    free(atlasDir);
    
    if (!atlas) {
        LOGE("Failed to create atlas from data");
        return nullptr;
    }
    LOGI("Atlas created successfully, pages: %p", atlas->pages);
    return atlas;
}

// 2. 读取Skeleton数据
static char* LoadSkeletonData(const char* skeletonPath, int* outLength)
{
    int skeletonLength = 0;
    char* skeletonData = SpineReadRawfile(skeletonPath, &skeletonLength);
    if (!skeletonData) {
        LOGE("Failed to read skeleton file from rawfile: %s", skeletonPath);
        return nullptr;
    }
    LOGI("Skeleton data loaded, length: %d", skeletonLength);
    
    if (outLength) {
        *outLength = skeletonLength;
    }
    return skeletonData;
}

// 3. 解析JSON格式的Skeleton
static spSkeletonData* ParseJsonSkeleton(spAtlas* atlas, const char* skeletonData, float scale)
{
    LOGI("Parsing skeleton as JSON format");
    spSkeletonJson* json = spSkeletonJson_create(atlas);
    json->scale = scale;
    spSkeletonData* skelData = spSkeletonJson_readSkeletonData(json, skeletonData);
    if (!skelData) {
        LOGE("Failed to parse skeleton JSON, error: %s", json->error ? json->error : "unknown");
    }
    spSkeletonJson_dispose(json);
    return skelData;
}

// 4. 解析二进制格式的Skeleton
static spSkeletonData* ParseBinarySkeleton(spAtlas* atlas, const char* skeletonData,
                                           int skeletonLength, float scale)
{
    LOGI("Parsing skeleton as binary format");
    spSkeletonBinary* binary = spSkeletonBinary_create(atlas);
    binary->scale = scale;
    spSkeletonData* skelData = spSkeletonBinary_readSkeletonData(binary, (const unsigned char*)skeletonData,
        skeletonLength);
    if (!skelData) {
        LOGE("Failed to parse skeleton binary, error: %s", binary->error ? binary->error : "unknown");
    }
    spSkeletonBinary_dispose(binary);
    return skelData;
}

// 5. 根据文件扩展名选择解析器
static spSkeletonData* ParseSkeletonByExtension(spAtlas* atlas, const char* skeletonData,
                                                int skeletonLength, const char* skeletonPath, float scale)
{
    const char* ext = strrchr(skeletonPath, '.');
    if (ext && (strcmp(ext, ".json") == 0 || strcmp(ext, ".JSON") == 0)) {
        return ParseJsonSkeleton(atlas, skeletonData, scale);
    } else {
        return ParseBinarySkeleton(atlas, skeletonData, skeletonLength, scale);
    }
}

// 6. 创建Spine实例结构体
static SpineInstance* CreateSpineInstanceStructure(spAtlas* atlas, spSkeletonData* skelData)
{
    SpineInstance* instance = new SpineInstance();
    instance->atlas = atlas;
    instance->skeletonData = skelData;
    instance->skeleton = spSkeleton_create(skelData);
    instance->animationStateData = spAnimationStateData_create(skelData);
    instance->animationState = spAnimationState_create(instance->animationStateData);
    // 设置默认混合时间
    instance->animationStateData->defaultMix = 0.2f;
    return instance;
}

// 7. 清理失败时的资源
static void CleanupFailedCreation(spAtlas* atlas, char* skeletonData)
{
    if (atlas) {
        spAtlas_dispose(atlas);
    }
    if (skeletonData) {
        free(skeletonData);
    }
}

// 8. 主函数
SpineInstance* SpineInstanceCreate(const char* atlasPath, const char* skeletonPath, float scale)
{
    // 加载Atlas数据
    spAtlas* atlas = LoadAtlasData(atlasPath);
    if (!atlas) {
        return nullptr;
    }
    // 加载Skeleton数据
    int skeletonLength = 0;
    char* skeletonData = LoadSkeletonData(skeletonPath, &skeletonLength);
    if (!skeletonData) {
        CleanupFailedCreation(atlas, nullptr);
        return nullptr;
    }
    // 解析Skeleton数据
    spSkeletonData* skelData = ParseSkeletonByExtension(
        atlas, skeletonData, skeletonLength, skeletonPath, scale);
    free(skeletonData);
    if (!skelData) {
        CleanupFailedCreation(atlas, nullptr);
        return nullptr;
    }
    
    // 创建实例
    SpineInstance* instance = CreateSpineInstanceStructure(atlas, skelData);
    
    LOGI("=== Spine instance created successfully ===");
    return instance;
}

void SpineInstanceDispose(SpineInstance* instance)
{
    if (!instance) { return; }
    spAnimationState_dispose(instance->animationState);
    spAnimationStateData_dispose(instance->animationStateData);
    spSkeleton_dispose(instance->skeleton);
    spSkeletonData_dispose(instance->skeletonData);
    spAtlas_dispose(instance->atlas);
    
    delete instance;
    LOGI("Spine instance disposed");
}

void SpineInstanceSetAnimation(SpineInstance* instance, int trackIndex, const char* animationName, int loop)
{
    if (!instance || !animationName) { return; }
    
    spAnimation* animation = spSkeletonData_findAnimation(instance->skeletonData, animationName);
    if (animation) {
        spAnimationState_setAnimation(instance->animationState, trackIndex, animation, loop);
        LOGI("Animation set: %s (loop=%d)", animationName, loop);
    } else {
        LOGE("Animation not found: %s", animationName);
    }
}

void SpineInstanceAddAnimation(SpineInstance* instance, int trackIndex, const char* animationName, int loop,
                               float delay)
{
    if (!instance || !animationName) { return; }
    
    spAnimation* animation = spSkeletonData_findAnimation(instance->skeletonData, animationName);
    if (animation) {
        spAnimationState_addAnimation(instance->animationState, trackIndex, animation, loop, delay);
        LOGI("Animation added: %s (loop=%d, delay=%.2f)", animationName, loop, delay);
    } else {
        LOGE("Animation not found: %s", animationName);
    }
}

void SpineInstanceUpdate(SpineInstance* instance, float deltaTime)
{
    if (!instance) { return; }
    
    spAnimationState_update(instance->animationState, deltaTime);
    spAnimationState_apply(instance->animationState, instance->skeleton);
    spSkeleton_update(instance->skeleton, deltaTime);
    spSkeleton_updateWorldTransform(instance->skeleton, SP_PHYSICS_UPDATE);
}

void SpineInstanceSetPosition(SpineInstance* instance, float x, float y)
{
    if (!instance) { return; }
    instance->skeleton->x = x;
    instance->skeleton->y = y;
}

void SpineInstanceSetScale(SpineInstance* instance, float scaleX, float scaleY)
{
    if (!instance) { return; }
    instance->skeleton->scaleX = scaleX;
    instance->skeleton->scaleY = scaleY;
}

// ============================================================================
// EGL 上下文管理
// ============================================================================

// 1. 创建基础上下文结构
static SpineContext* CreateBaseContext(int width, int height)
{
    LOGI("Creating spine context: %dx%d", width, height);
    SpineContext* ctx = new SpineContext();
    ctx->width = width;
    ctx->height = height;
    ctx->display = EGL_NO_DISPLAY;
    ctx->surface = EGL_NO_SURFACE;
    ctx->context = EGL_NO_CONTEXT;
    ctx->renderer = nullptr;
    return ctx;
}

// 2. 初始化EGL显示
static bool InitializeEglDisplay(EGLDisplay* display)
{
    *display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    if (*display == EGL_NO_DISPLAY) {
        LOGE("eglGetDisplay failed");
        return false;
    }
    
    EGLint minorVersion;
    EGLint majorVersion;
    if (!eglInitialize(*display, &majorVersion, &minorVersion)) {
        LOGE("eglInitialize failed");
        return false;
    }
    LOGI("EGL initialized: version %d.%d", majorVersion, minorVersion);
    return true;
}

// 3. 选择EGL配置
static bool ChooseEglConfig(EGLDisplay display, EGLConfig* config)
{
    EGLint configAttribs[] = {
        EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
        EGL_RENDERABLE_TYPE, EGL_OPENGL_ES3_BIT,
        EGL_RED_SIZE, 8,
        EGL_GREEN_SIZE, 8,
        EGL_BLUE_SIZE, 8,
        EGL_ALPHA_SIZE, 8,
        EGL_DEPTH_SIZE, 0,
        EGL_STENCIL_SIZE, 0,
        EGL_NONE
    };
    
    EGLint numConfigs;
    if (!eglChooseConfig(display, configAttribs, config, 1, &numConfigs) || numConfigs == 0) {
        LOGE("eglChooseConfig failed");
        return false;
    }
    
    return true;
}

// 4. 创建EGL表面
static EGLSurface CreateEglSurface(EGLDisplay display, EGLConfig config, void* window)
{
    EGLSurface surface = eglCreateWindowSurface(display, config, (EGLNativeWindowType)window, nullptr);
    if (surface == EGL_NO_SURFACE) {
        LOGE("eglCreateWindowSurface failed");
    }
    
    return surface;
}

// 5. 创建EGL上下文
static EGLContext CreateEglContext(EGLDisplay display, EGLConfig config)
{
    EGLint contextAttribs[] = {EGL_CONTEXT_CLIENT_VERSION, 3, EGL_NONE};
    EGLContext context = eglCreateContext(display, config, EGL_NO_CONTEXT, contextAttribs);
    if (context == EGL_NO_CONTEXT) {
        LOGE("eglCreateContext failed");
    }
    return context;
}

// 6. 绑定EGL上下文
static bool MakeEglContextCurrent(EGLDisplay display, EGLSurface surface, EGLContext context)
{
    if (!eglMakeCurrent(display, surface, surface, context)) {
        LOGE("eglMakeCurrent failed");
        return false;
    }
    LOGI("EGL context created successfully");
    return true;
}

// 7. 创建并配置渲染器
static SpineRenderer* CreateAndSetupRenderer(int width, int height)
{
    SpineRenderer* renderer = SpineRendererCreate();
    if (!renderer) {
        LOGE("Failed to create renderer");
        return nullptr;
    }
    
    SpineRendererSetViewport(renderer, width, height);
    return renderer;
}

// 9. 清理EGL资源
static void CleanupEglResources(EGLDisplay display, EGLSurface surface, EGLContext context)
{
    if (display != EGL_NO_DISPLAY) {
        eglMakeCurrent(display, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
        
        if (context != EGL_NO_CONTEXT) {
            eglDestroyContext(display, context);
        }
        
        if (surface != EGL_NO_SURFACE) {
            eglDestroySurface(display, surface);
        }
        eglTerminate(display);
    }
}

// 10. 清理部分上下文资源（不包含渲染器）
static void CleanupPartialContext(SpineContext* ctx)
{
    if (ctx) {
        CleanupEglResources(ctx->display, ctx->surface, ctx->context);
        delete ctx;
    }
}

// 11. 清理完整上下文资源
static void CleanupFullContext(SpineContext* ctx)
{
    if (ctx) {
        CleanupEglResources(ctx->display, ctx->surface, ctx->context);
        delete ctx;
    }
}

// 12. 主函数
SpineContext* SpineContextCreate(void* window, int width, int height)
{
    // 创建基础上下文
    SpineContext* ctx = CreateBaseContext(width, height);
    if (!ctx) {
        return nullptr;
    }
    // 初始化EGL显示
    if (!InitializeEglDisplay(&ctx->display)) {
        delete ctx;
        return nullptr;
    }
    // 选择EGL配置
    if (!ChooseEglConfig(ctx->display, &ctx->config)) {
        CleanupEglResources(ctx->display, EGL_NO_SURFACE, EGL_NO_CONTEXT);
        delete ctx;
        return nullptr;
    }
    // 创建EGL表面
    ctx->surface = CreateEglSurface(ctx->display, ctx->config, window);
    if (ctx->surface == EGL_NO_SURFACE) {
        CleanupEglResources(ctx->display, EGL_NO_SURFACE, EGL_NO_CONTEXT);
        delete ctx;
        return nullptr;
    }
    // 创建EGL上下文
    ctx->context = CreateEglContext(ctx->display, ctx->config);
    if (ctx->context == EGL_NO_CONTEXT) {
        CleanupEglResources(ctx->display, ctx->surface, EGL_NO_CONTEXT);
        delete ctx;
        return nullptr;
    }
    // 绑定EGL上下文
    if (!MakeEglContextCurrent(ctx->display, ctx->surface, ctx->context)) {
        CleanupEglResources(ctx->display, ctx->surface, ctx->context);
        delete ctx;
        return nullptr;
    }
    // 创建并配置渲染器
    ctx->renderer = CreateAndSetupRenderer(width, height);
    if (!ctx->renderer) {
        CleanupFullContext(ctx);
        return nullptr;
    }
    LOGI("Spine context created successfully");
    return ctx;
}

void SpineContextDispose(SpineContext* context)
{
    if (!context) { return; }
    // 释放所有 Spine 实例
    for (auto& pair : context->instances) {
        SpineInstanceDispose(pair.second);
    }
    context->instances.clear();
    
    // 释放渲染器
    SpineRendererDispose(context->renderer);
    
    // 释放 EGL 资源
    eglMakeCurrent(context->display, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
    eglDestroyContext(context->display, context->context);
    eglDestroySurface(context->display, context->surface);
    eglTerminate(context->display);
    
    delete context;
    LOGI("Spine context disposed");
}

void SpineContextResize(SpineContext* context, int width, int height)
{
    if (!context) { return; }
    
    context->width = width;
    context->height = height;
    SpineRendererSetViewport(context->renderer, width, height);
    LOGI("Context resized: %dx%d", width, height);
}

void SpineContextRender(SpineContext* context, float deltaTime)
{
    if (!context) { return; }
    
    // 确保上下文是当前的
    eglMakeCurrent(context->display, context->surface, context->surface, context->context);
    
    // 清屏
    glClearColor(0.2f, 0.2f, 0.2f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 更新和绘制所有实例
    for (auto& pair : context->instances) {
        SpineInstance* instance = pair.second;
        SpineInstanceUpdate(instance, deltaTime);
        SpineRendererDraw(context->renderer, instance->skeleton);
    }
    
    // 交换缓冲区
    eglSwapBuffers(context->display, context->surface);
}

void SpineContextAddInstance(SpineContext* context, const char* name, SpineInstance* instance)
{
    if (!context || !name || !instance) { return; }
    
    // 如果已存在同名实例，先释放
    auto it = context->instances.find(name);
    if (it != context->instances.end()) {
        SpineInstanceDispose(it->second);
    }
    
    context->instances[name] = instance;
    LOGI("Instance added: %s", name);
}

void SpineContextRemoveInstance(SpineContext* context, const char* name)
{
    if (!context || !name) { return; }
    
    auto it = context->instances.find(name);
    if (it != context->instances.end()) {
        SpineInstanceDispose(it->second);
        context->instances.erase(it);
        LOGI("Instance removed: %s", name);
    }
}

SpineInstance* SpineContextGetInstance(SpineContext* context, const char* name)
{
    if (!context || !name) { return nullptr; }
    
    auto it = context->instances.find(name);
    if (it != context->instances.end()) {
        return it->second;
    }
    return nullptr;
}
