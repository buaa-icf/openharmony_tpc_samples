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
 * Spine Harmony Runtime - 鸿蒙平台 Spine 渲染实现
 * 基于 spine-c 和 OpenGL ES 3.0
 *****************************************************************************/

#ifndef SPINE_HARMONY_H
#define SPINE_HARMONY_H

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl3.h>
#include <string>
#include <vector>
#include <map>
#include "thirdparty/spinec/include/spine/spine.h"
#ifdef __cplusplus
extern "C" {
#endif
#ifdef __cplusplus
}
#endif

// ============================================================================
// 纹理管理
// ============================================================================

typedef struct {
    GLuint id;
    int width;
    int height;
} SpineTexture;

// 加载纹理（使用 stb_image）
SpineTexture* SpineTextureLoad(const char* path);
SpineTexture* SpineTextureLoadFromMemory(const unsigned char* data, int length);
void SpineTextureDispose(SpineTexture* texture);

// ============================================================================
// 顶点数据结构
// ============================================================================

typedef struct {
    float x, y;           // 位置
    float u, v;           // 纹理坐标
    float r, g, b, a;     // 颜色
} SpineVertex;

// ============================================================================
// 渲染器
// ============================================================================

typedef struct {
    GLuint program;
    GLuint vao;
    GLuint vbo;
    GLuint ibo;
    
    GLint uMatrix;
    GLint uTexture;
    
    std::vector<SpineVertex> vertices;
    std::vector<unsigned short> indices;
    
    float projectionMatrix[16];
    
    // 裁剪支持
    spSkeletonClipping* clipper;
    float* worldVertices;
    int worldVerticesCapacity;
} SpineRenderer;

SpineRenderer* SpineRendererCreate();
void SpineRendererDispose(SpineRenderer* renderer);
void SpineRendererSetViewport(SpineRenderer* renderer, int width, int height);
void SpineRendererDraw(SpineRenderer* renderer, spSkeleton* skeleton);

// ============================================================================
// Spine 骨骼管理
// ============================================================================

typedef struct {
    spAtlas* atlas;
    spSkeletonData* skeletonData;
    spSkeleton* skeleton;
    spAnimationStateData* animationStateData;
    spAnimationState* animationState;
} SpineInstance;

SpineInstance* SpineInstanceCreate(const char* atlasPath, const char* skeletonPath, float scale);
void SpineInstanceDispose(SpineInstance* instance);
void SpineInstanceSetAnimation(SpineInstance* instance, int trackIndex, const char* animationName, int loop);
void SpineInstanceAddAnimation(SpineInstance* instance, int trackIndex, const char* animationName,
                               int loop, float delay);
void SpineInstanceUpdate(SpineInstance* instance, float deltaTime);
void SpineInstanceSetPosition(SpineInstance* instance, float x, float y);
void SpineInstanceSetScale(SpineInstance* instance, float scaleX, float scaleY);

// ============================================================================
// EGL 上下文管理（用于 XComponent）
// ============================================================================

typedef struct {
    EGLDisplay display;
    EGLSurface surface;
    EGLContext context;
    EGLConfig config;
    int width;
    int height;
    
    SpineRenderer* renderer;
    std::map<std::string, SpineInstance*> instances;
} SpineContext;

SpineContext* SpineContextCreate(void* window, int width, int height);
void SpineContextDispose(SpineContext* context);
void SpineContextResize(SpineContext* context, int width, int height);
void SpineContextRender(SpineContext* context, float deltaTime);

// 实例管理
void SpineContextAddInstance(SpineContext* context, const char* name, SpineInstance* instance);
void SpineContextRemoveInstance(SpineContext* context, const char* name);
SpineInstance* SpineContextGetInstance(SpineContext* context, const char* name);

// ============================================================================
// 文件工具（鸿蒙 rawfile 支持）
// ============================================================================

// 设置资源管理器（从 ArkTS 传入）
void SpineSetResourceManager(void* resMgr);

// 读取 rawfile 文件
char* SpineReadRawfile(const char* path, int* length);

#endif // SPINE_HARMONY_H
