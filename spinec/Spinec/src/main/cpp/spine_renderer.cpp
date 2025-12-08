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
 * Spine Harmony Runtime - OpenGL ES 渲染器实现
 *****************************************************************************/

#include "spine_harmony.h"
#include <cstring>
#include <cmath>
#include <hilog/log.h>
#include "securec.h"

#define LOG_TAG "SpineRenderer"
#define LOGI(...) OH_LOG_INFO(LOG_APP, __VA_ARGS__)
#define LOGE(...) OH_LOG_ERROR(LOG_APP, __VA_ARGS__)
#define INDEX_0 0
#define INDEX_1 1
#define INDEX_2 2
#define INDEX_4 4
#define INDEX_6 6
#define INDEX_8 8
// ============================================================================
// Shader 源码
// ============================================================================

static const char* VERTEX_SHADER = R"(#version 300 es
layout(location = 0) in vec2 aPosition;
layout(location = 1) in vec2 aTexCoord;
layout(location = 2) in vec4 aColor;

uniform mat4 uMatrix;

out vec2 vTexCoord;
out vec4 vColor;

void main() {
    vTexCoord = aTexCoord;
    vColor = aColor;
    gl_Position = uMatrix * vec4(aPosition, 0.0, 1.0);
}
)";

static const char* FRAGMENT_SHADER = R"(#version 300 es
precision mediump float;

in vec2 vTexCoord;
in vec4 vColor;

uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
    vec4 texColor = texture(uTexture, vTexCoord);
    fragColor = texColor * vColor;
}
)";

// ============================================================================
// Shader 编译辅助函数
// ============================================================================

static GLuint compileShader(GLenum type, const char* source)
{
    GLuint shader = glCreateShader(type);
    glShaderSource(shader, 1, &source, nullptr);
    glCompileShader(shader);
    int infoLognumber = 512;
    GLint success;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    if (!success) {
        char infoLog[infoLognumber];
        glGetShaderInfoLog(shader, infoLognumber, nullptr, infoLog);
        LOGE("Shader compilation failed: %s", infoLog);
        glDeleteShader(shader);
        return 0;
    }
    
    return shader;
}

static GLuint createProgram(const char* vertexSource, const char* fragmentSource)
{
    GLuint vertexShader = compileShader(GL_VERTEX_SHADER, vertexSource);
    GLuint fragmentShader = compileShader(GL_FRAGMENT_SHADER, fragmentSource);
    if (!vertexShader || !fragmentShader) {
        return 0;
    }
    GLuint program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);
    int infoLognumber = 512;
    GLint success;
    glGetProgramiv(program, GL_LINK_STATUS, &success);
    if (!success) {
        char infoLog[infoLognumber];
        glGetProgramInfoLog(program, infoLognumber, nullptr, infoLog);
        LOGE("Program linking failed: %s", infoLog);
        glDeleteProgram(program);
        program = 0;
    }
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    return program;
}

// ============================================================================
// 矩阵辅助函数
// ============================================================================

// 定义正交投影参数结构体
typedef struct {
    float left;
    float right;
    float bottom;
    float top;
    float near;
    float far;
} OrthoProjectionParams;

// 使用结构体版本
static void OrthoMatrix(float* matrix, OrthoProjectionParams* params)
{
    const int index0 = 0;
    const int index5 = 5;
    const int index16 = 16;
    
    // 初始化矩阵为零
    for (int i = index0; i < index16; i++) {
        matrix[i] = 0;
    }
    
    // 设置正交投影矩阵元素
    matrix[index0] = 2.0f / (params->right - params->left);
    matrix[index5] = 2.0f / (params->top - params->bottom);
    
    const int index10 = 10;
    matrix[index10] = -2.0f / (params->far - params->near);
    
    const int index12 = 12;
    const int index13 = 13;
    const int index14 = 14;
    const int index15 = 15;
    
    matrix[index12] = -(params->right + params->left) / (params->right - params->left);
    matrix[index13] = -(params->top + params->bottom) / (params->top - params->bottom);
    matrix[index14] = -(params->far + params->near) / (params->far - params->near);
    matrix[index15] = 1.0f;
}

// ============================================================================
// 渲染器实现
// ============================================================================

SpineRenderer* SpineRendererCreate()
{
    SpineRenderer* renderer = new SpineRenderer();
    
    // 创建 shader 程序
    renderer->program = createProgram(VERTEX_SHADER, FRAGMENT_SHADER);
    if (!renderer->program) {
        delete renderer;
        return nullptr;
    }
    
    // 获取 uniform 位置
    renderer->uMatrix = glGetUniformLocation(renderer->program, "uMatrix");
    renderer->uTexture = glGetUniformLocation(renderer->program, "uTexture");
    
    // 创建 VAO, VBO, IBO
    glGenVertexArrays(1, &renderer->vao);
    glGenBuffers(1, &renderer->vbo);
    glGenBuffers(1, &renderer->ibo);
    
    glBindVertexArray(renderer->vao);
    
    glBindBuffer(GL_ARRAY_BUFFER, renderer->vbo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, renderer->ibo);
    int zero = 0;
    int one = 1;
    int two = 2;
    int four = 4;
    // 位置属性
    glVertexAttribPointer(zero, two, GL_FLOAT, GL_FALSE, sizeof(SpineVertex), (void*)offsetof(SpineVertex, x));
    glEnableVertexAttribArray(zero);
    
    // 纹理坐标属性
    glVertexAttribPointer(one, two, GL_FLOAT, GL_FALSE, sizeof(SpineVertex), (void*)offsetof(SpineVertex, u));
    glEnableVertexAttribArray(one);
    
    // 颜色属性
    glVertexAttribPointer(two, four, GL_FLOAT, GL_FALSE, sizeof(SpineVertex), (void*)offsetof(SpineVertex, r));
    glEnableVertexAttribArray(two);
    
    glBindVertexArray(zero);
    
    // 初始化裁剪器
    renderer->clipper = spSkeletonClipping_create();
    renderer->worldVertices = nullptr;
    renderer->worldVerticesCapacity = 0;
    
    LOGI("Renderer created");
    return renderer;
}

void SpineRendererDispose(SpineRenderer* renderer)
{
    if (!renderer) { return; }
    
    glDeleteProgram(renderer->program);
    glDeleteVertexArrays(1, &renderer->vao);
    glDeleteBuffers(1, &renderer->vbo);
    glDeleteBuffers(1, &renderer->ibo);
    
    spSkeletonClipping_dispose(renderer->clipper);
    if (renderer->worldVertices) {
        free(renderer->worldVertices);
    }
    
    delete renderer;
    LOGI("Renderer disposed");
}

void SpineRendererSetViewport(SpineRenderer* renderer, int width, int height)
{
    glViewport(0, 0, width, height);
    // 创建正交投影参数
    OrthoProjectionParams params = {
        .left = 0.0f,
        .right = static_cast<float>(width),
        .bottom = 0.0f,
        .top = static_cast<float>(height),
        .near = -1.0f,
        .far = 1.0f
    };
    // Y 轴向上，原点在左下角
    OrthoMatrix(renderer->projectionMatrix, &params);
    LOGI("Viewport set: %dx%d", width, height);
}

// 确保 worldVertices 容量足够
static void EnsureWorldVerticesCapacity(SpineRenderer* renderer, int capacity)
{
    if (renderer->worldVerticesCapacity < capacity) {
        int oldCapacity = renderer->worldVerticesCapacity;
        renderer->worldVerticesCapacity = capacity;
        float* newWorldVertices = (float*)malloc(capacity * sizeof(float));
        if (renderer->worldVertices != nullptr) {
            // 复制原有数据到新数组
            memcpy_s(newWorldVertices, sizeof(float), renderer->worldVertices,
                     oldCapacity * sizeof(float));
            free(renderer->worldVertices);
        }
        renderer->worldVertices = newWorldVertices;
    }
}

// 辅助函数：设置混合模式
static void setBlendMode(spBlendMode blendMode, bool premultipliedAlpha)
{
    switch (blendMode) {
        case SP_BLEND_MODE_NORMAL:
            if (premultipliedAlpha) {
                glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
            } else {
                glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            }
            break;
        case SP_BLEND_MODE_ADDITIVE:
            if (premultipliedAlpha) {
                glBlendFunc(GL_ONE, GL_ONE);
            } else {
                glBlendFunc(GL_SRC_ALPHA, GL_ONE);
            }
            break;
        case SP_BLEND_MODE_MULTIPLY:
            glBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
            break;
        case SP_BLEND_MODE_SCREEN:
            glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);
            break;
        default:
            glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
            break;
    }
}


// 辅助结构体定义
typedef struct {
    SpineTexture* texture;
    float* vertices;
    float* uvs;
    unsigned short* triangles;
    int verticesCount;
    int trianglesCount;
    float r, g, b, a;
    spColor* attachmentColor;
} AttachmentData;

typedef struct {
    spSkeleton* skeleton;
    spSlot* slot;
    spColor* attachmentColor;
} ColorCalcData;

typedef struct {
    spSlot* slot;
    spAttachment* attachment;
} BlendSettingsData;

typedef struct {
    SpineRenderer* renderer;
    SpineTexture* texture;
    unsigned short vertexIndex;
} FlushBatchData;

// 初始化渲染状态
void InitRenderState(SpineRenderer* renderer)
{
    if (!renderer) { return; }
    
    renderer->vertices.clear();
    renderer->indices.clear();
    
    glUseProgram(renderer->program);
    glUniformMatrix4fv(renderer->uMatrix, INDEX_1, GL_FALSE, renderer->projectionMatrix);
    glUniform1i(renderer->uTexture, INDEX_0);
    
    glEnable(GL_BLEND);
    setBlendMode(SP_BLEND_MODE_NORMAL, true);
}

// 处理区域附件
int ProcessRegionAttachment(SpineRenderer* renderer, spRegionAttachment* region, spSlot* slot)
{
    if (!renderer || !region || !slot) { return 0; }
    
    EnsureWorldVerticesCapacity(renderer, INDEX_8);
    spRegionAttachment_computeWorldVertices(region, slot, renderer->worldVertices, INDEX_0, INDEX_2);
    return 1;
}

// 填充区域附件数据
void FillRegionData(spRegionAttachment* region, SpineRenderer* renderer, AttachmentData* data)
{
    if (!region || !renderer || !data) { return; }
    
    data->attachmentColor = &region->color;
    data->texture = (SpineTexture*)((spAtlasRegion*)region->rendererObject)
                    ->page->rendererObject;
    data->vertices = renderer->worldVertices;
    data->verticesCount = INDEX_4;
    data->uvs = region->uvs;
    
    static unsigned short quadTriangles[] = {0, 1, 2, 2, 3, 0};
    data->triangles = quadTriangles;
    data->trianglesCount = INDEX_6;
}

// 处理网格附件
int ProcessMeshAttachment(SpineRenderer* renderer, spMeshAttachment* mesh, spSlot* slot)
{
    if (!renderer || !mesh || !slot) { return 0; }
    
    int worldVerticesLength = mesh->super.worldVerticesLength;
    EnsureWorldVerticesCapacity(renderer, worldVerticesLength);
    
    spVertexAttachment_computeWorldVertices(&mesh->super, slot, INDEX_0, worldVerticesLength, renderer->worldVertices,
                                            INDEX_0, INDEX_2);
    return 1;
}

// 填充网格附件数据
void FillMeshData(spMeshAttachment* mesh, SpineRenderer* renderer, AttachmentData* data)
{
    if (!mesh || !renderer || !data) { return; }
    
    data->attachmentColor = &mesh->color;
    data->texture = (SpineTexture*)((spAtlasRegion*)mesh->rendererObject)
                    ->page->rendererObject;
    data->vertices = renderer->worldVertices;
    data->verticesCount = mesh->super.worldVerticesLength / INDEX_2;
    data->uvs = mesh->uvs;
    data->triangles = mesh->triangles;
    data->trianglesCount = mesh->trianglesCount;
}

// 获取附件数据
int GetAttachmentData(SpineRenderer* renderer, spAttachment* attachment, spSlot* slot)
{
    if (!renderer || !attachment || !slot) { return 0; }
    
    if (attachment->type == SP_ATTACHMENT_REGION) {
        return ProcessRegionAttachment(renderer, (spRegionAttachment*)attachment, slot);
    } else if (attachment->type == SP_ATTACHMENT_MESH) {
        return ProcessMeshAttachment(renderer, (spMeshAttachment*)attachment, slot);
    } else if (attachment->type == SP_ATTACHMENT_CLIPPING) {
        spClippingAttachment* clip = (spClippingAttachment*)attachment;
        spSkeletonClipping_clipStart(renderer->clipper, slot, clip);
        return 0;
    }

    return 0;
}

// 填充附件数据
void FillAttachmentData(SpineRenderer* renderer, spAttachment* attachment, AttachmentData* data)
{
    if (!renderer || !attachment || !data) { return; }
    
    memset_s(data, sizeof(AttachmentData), 0, sizeof(AttachmentData));
    
    if (attachment->type == SP_ATTACHMENT_REGION) {
        FillRegionData((spRegionAttachment*)attachment, renderer, data);
    } else if (attachment->type == SP_ATTACHMENT_MESH) {
        FillMeshData((spMeshAttachment*)attachment, renderer, data);
    }
}

// 计算颜色值
void CalculateColor(ColorCalcData* data, bool pma)
{
    if (!data || !data->skeleton || !data->slot || !data->attachmentColor) { return; }
    
    float r = data->skeleton->color.r * data->slot->color.r * data->attachmentColor->r;
    float g = data->skeleton->color.g * data->slot->color.g * data->attachmentColor->g;
    float b = data->skeleton->color.b * data->slot->color.b * data->attachmentColor->b;
    float a = data->skeleton->color.a * data->slot->color.a * data->attachmentColor->a;
    
    if (pma) {
        r *= a;
        g *= a;
        b *= a;
    }
    data->attachmentColor->r = r;
    data->attachmentColor->g = g;
    data->attachmentColor->b = b;
    data->attachmentColor->a = a;
}

// 获取混合模式
void GetBlendMode(BlendSettingsData* data, spBlendMode* blendMode, bool* pma)
{
    if (!data || !data->slot || !blendMode || !pma) { return; }
    
    *blendMode = data->slot->data->blendMode;
    
    spAtlasRegion* atlasRegion = nullptr;
    if (data->attachment->type == SP_ATTACHMENT_REGION) {
        atlasRegion = (spAtlasRegion*)((spRegionAttachment*)data->attachment)->rendererObject;
    } else if (data->attachment->type == SP_ATTACHMENT_MESH) {
        atlasRegion = (spAtlasRegion*)((spMeshAttachment*)data->attachment)->rendererObject;
    }
    
    *pma = atlasRegion && atlasRegion->page ? atlasRegion->page->pma : true;
}

// 应用裁剪
int ApplyClipping(SpineRenderer* renderer, AttachmentData* data)
{
    if (!renderer || !data) { return 0; }
    
    if (!spSkeletonClipping_isClipping(renderer->clipper)) { return 1; }
    
    spSkeletonClipping_clipTriangles(renderer->clipper, data->vertices, data->verticesCount * INDEX_2,
                                     data->triangles, data->trianglesCount, data->uvs, INDEX_2);
    
    if (renderer->clipper->clippedTriangles->size == INDEX_0) {
        return 0;
    }
    data->vertices = renderer->clipper->clippedVertices->items;
    data->verticesCount = renderer->clipper->clippedVertices->size / INDEX_2;
    data->uvs = renderer->clipper->clippedUVs->items;
    data->triangles = renderer->clipper->clippedTriangles->items;
    data->trianglesCount = renderer->clipper->clippedTriangles->size;
    
    return 1;
}

// 批次检查参数结构体
typedef struct {
    SpineRenderer* renderer;
    SpineTexture* lastTexture;
    spBlendMode lastBlendMode;
    bool lastPremultipliedAlpha;
    SpineTexture* currentTexture;
    spBlendMode currentBlendMode;
    bool currentPma;
} BatchCheckParams;

// 检查是否需要刷新批次
int CheckNeedFlush(BatchCheckParams* params)
{
    if (!params || !params->renderer || params->renderer->vertices.empty()) {
        return 0;
    }
    
    if (!params->lastTexture) {
        return 0;
    }
    
    if (params->lastTexture != params->currentTexture) {
        return 1;
    }
    
    if (params->lastBlendMode != params->currentBlendMode) {
        return 1;
    }
    
    if (params->lastPremultipliedAlpha != params->currentPma) {
        return 1;
    }
    
    return 0;
}

// 刷新批次
void FlushBatch(FlushBatchData* data)
{
    if (!data || !data->renderer || !data->texture) { return; }
    
    if (data->renderer->vertices.empty()) { return; }
    
    glBindVertexArray(data->renderer->vao);
    glBindBuffer(GL_ARRAY_BUFFER, data->renderer->vbo);
    glBufferData(GL_ARRAY_BUFFER, data->renderer->vertices.size() * sizeof(SpineVertex),
                 data->renderer->vertices.data(), GL_DYNAMIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, data->renderer->ibo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, data->renderer->indices.size() * sizeof(unsigned short),
                 data->renderer->indices.data(), GL_DYNAMIC_DRAW);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, data->texture->id);
    glDrawElements(GL_TRIANGLES, (GLsizei)data->renderer->indices.size(), GL_UNSIGNED_SHORT, 0);
}

// 添加顶点和索引
void AddVerticesAndIndices(SpineRenderer* renderer, AttachmentData* data, unsigned short vertexIndex)
{
    if (!renderer || !data || !data->vertices || !data->uvs) { return; }
    
    // 添加顶点
    for (int v = INDEX_0; v < data->verticesCount; v++) {
        SpineVertex vertex;
        vertex.x = data->vertices[v * INDEX_2];
        vertex.y = data->vertices[v * INDEX_2 + INDEX_1];
        vertex.u = data->uvs[v * INDEX_2];
        vertex.v = data->uvs[v * INDEX_2 + INDEX_1];
        vertex.r = data->r;
        vertex.g = data->g;
        vertex.b = data->b;
        vertex.a = data->a;
        renderer->vertices.push_back(vertex);
    }
    // 添加索引
    if (data->triangles) {
        for (int t = INDEX_0; t < data->trianglesCount; t++) {
            renderer->indices.push_back(vertexIndex + data->triangles[t]);
        }
    }
}

// 绘制最后批次
void DrawFinalBatch(SpineRenderer* renderer, SpineTexture* texture)
{
    if (!renderer || renderer->vertices.empty() || !texture) { return; }
    
    FlushBatchData flushData = {renderer, texture, 0};
    FlushBatch(&flushData);
}

// 清理渲染状态
void CleanupRenderState(SpineRenderer* renderer)
{
    if (!renderer) { return; }
    
    glBindVertexArray(0);
    glDisable(GL_BLEND);
}

// 主渲染函数的参数结构体
typedef struct {
    SpineRenderer* renderer;
    spSkeleton* skeleton;
} SpineDrawParams;

// 批次渲染状态结构体
typedef struct {
    SpineTexture* lastTexture;
    spBlendMode lastBlendMode;
    bool lastPremultipliedAlpha;
    unsigned short vertexIndex;
} BatchRenderState;

// 槽位处理数据
typedef struct {
    SpineRenderer* renderer;
    spSlot* slot;
    spSkeleton* skeleton;
    BatchRenderState* batchState;
} SlotProcessData;

// 槽位渲染数据结构体定义
typedef struct SlotRenderData {
    SpineRenderer* renderer;
    spSlot* slot;
    AttachmentData* attData;
    BatchRenderState* batchState;
    spBlendMode currentBlendMode;
    bool currentPma;
} SlotRenderData;

// 更新混合模式
void UpdateBlendMode(SlotRenderData* data)
{
    if (!data || !data->batchState) { return; }
    
    if (data->batchState->lastBlendMode != data->currentBlendMode ||
        data->batchState->lastPremultipliedAlpha != data->currentPma ||
        !data->batchState->lastTexture) {
        setBlendMode(data->currentBlendMode, data->currentPma);
        data->batchState->lastBlendMode = data->currentBlendMode;
        data->batchState->lastPremultipliedAlpha = data->currentPma;
    }
}

// 使用数据渲染槽位
void RenderSlotWithData(SlotRenderData* data)
{
    if (!data || !data->renderer || !data->slot || !data->attData || !data->batchState) {
        return;
    }
    
    // 准备批次检查参数
    BatchCheckParams checkParams;
    checkParams.renderer = data->renderer;
    checkParams.lastTexture = data->batchState->lastTexture;
    checkParams.lastBlendMode = data->batchState->lastBlendMode;
    checkParams.lastPremultipliedAlpha = data->batchState->lastPremultipliedAlpha;
    checkParams.currentTexture = data->attData->texture;
    checkParams.currentBlendMode = data->currentBlendMode;
    checkParams.currentPma = data->currentPma;
    
    // 检查是否需要刷新批次
    if (CheckNeedFlush(&checkParams)) {
        FlushBatchData flushData;
        flushData.renderer = data->renderer;
        flushData.texture = data->batchState->lastTexture;
        flushData.vertexIndex = data->batchState->vertexIndex;
        FlushBatch(&flushData);
        
        data->renderer->vertices.clear();
        data->renderer->indices.clear();
        data->batchState->vertexIndex = INDEX_0;
    }
    
    // 更新混合模式
    UpdateBlendMode(data);
    
    data->batchState->lastTexture = data->attData->texture;
    
    // 添加顶点和索引
    AddVerticesAndIndices(data->renderer, data->attData, data->batchState->vertexIndex);
    data->batchState->vertexIndex += data->attData->verticesCount;
    
    spSkeletonClipping_clipEnd(data->renderer->clipper, data->slot);
}

// 处理单个槽位
void ProcessSingleSlot(SlotProcessData* data)
{
    if (!data || !data->renderer || !data->slot || !data->skeleton || !data->batchState) {
        return;
    }
    spAttachment* attachment = data->slot->attachment;
    if (!attachment) { return; }
    AttachmentData attData;
    BlendSettingsData blendData;
    ColorCalcData colorData;
    // 获取附件数据
    if (!GetAttachmentData(data->renderer, attachment, data->slot)) { return; }
    FillAttachmentData(data->renderer, attachment, &attData);
    if (!attData.texture || !attData.vertices || attData.verticesCount == INDEX_0) {
        spSkeletonClipping_clipEnd(data->renderer->clipper, data->slot);
        return;
    }
    // 获取混合设置
    blendData.slot = data->slot;
    blendData.attachment = attachment;
    spBlendMode currentBlendMode;
    bool currentPma;
    GetBlendMode(&blendData, &currentBlendMode, &currentPma);
    // 计算颜色
    colorData.skeleton = data->skeleton;
    colorData.slot = data->slot;
    colorData.attachmentColor = attData.attachmentColor;
    CalculateColor(&colorData, currentPma);
    attData.r = colorData.attachmentColor->r;
    attData.g = colorData.attachmentColor->g;
    attData.b = colorData.attachmentColor->b;
    attData.a = colorData.attachmentColor->a;
    // 应用裁剪
    if (!ApplyClipping(data->renderer, &attData)) {
        spSkeletonClipping_clipEnd(data->renderer->clipper, data->slot);
        return;
    }
    // 准备槽位渲染数据
    SlotRenderData slotRenderData;
    slotRenderData.renderer = data->renderer;
    slotRenderData.slot = data->slot;
    slotRenderData.attData = &attData;
    slotRenderData.batchState = data->batchState;
    slotRenderData.currentBlendMode = currentBlendMode;
    slotRenderData.currentPma = currentPma;
    // 渲染槽位
    RenderSlotWithData(&slotRenderData);
}

// 遍历并渲染所有槽位
void RenderAllSlots(SpineDrawParams* params, BatchRenderState* batchState)
{
    if (!params || !params->skeleton || !batchState) { return; }
    
    for (int i = INDEX_0; i < params->skeleton->slotsCount; i++) {
        spSlot* slot = params->skeleton->drawOrder[i];
        
        SlotProcessData slotData;
        slotData.renderer = params->renderer;
        slotData.slot = slot;
        slotData.skeleton = params->skeleton;
        slotData.batchState = batchState;
        
        ProcessSingleSlot(&slotData);
    }
}

// 完成渲染
void FinishRender(SpineRenderer* renderer, SpineTexture* lastTexture)
{
    if (!renderer) { return; }
    
    spSkeletonClipping_clipEnd2(renderer->clipper);
    
    if (!renderer->vertices.empty() && lastTexture) {
        DrawFinalBatch(renderer, lastTexture);
    }
    
    CleanupRenderState(renderer);
}

// 主渲染函数（参数小于3个）
void SpineRendererDrawMain(SpineDrawParams* params)
{
    if (!params || !params->renderer || !params->skeleton) { return; }
    
    InitRenderState(params->renderer);
    
    BatchRenderState batchState;
    batchState.lastTexture = nullptr;
    batchState.lastBlendMode = SP_BLEND_MODE_NORMAL;
    batchState.lastPremultipliedAlpha = true;
    batchState.vertexIndex = INDEX_0;
    
    RenderAllSlots(params, &batchState);
    FinishRender(params->renderer, batchState.lastTexture);
}

// 主渲染函数（兼容原始接口）
void SpineRendererDraw(SpineRenderer* renderer, spSkeleton* skeleton)
{
    SpineDrawParams params;
    params.renderer = renderer;
    params.skeleton = skeleton;
    
    SpineRendererDrawMain(&params);
}
