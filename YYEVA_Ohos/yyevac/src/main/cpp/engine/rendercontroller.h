//
// Created by zengjiale on 2022/4/22.
//
#pragma once

#include "irender.h"
#ifndef __OHOS__
#include <android/native_window_jni.h>
#else
#include <ohos/ohos_window.h>
#endif
#include <egl/eglcore.h>
#include <mix/evamixrender.h>
#include <bean/evaframeall.h>
#include <list>
#include <engine/render.h>
#include <engine/yuvrender.h>
#include <engine/bgrender.h>
#include <engine/mp4render.h>
#include <engine/fbrender.h>
#include <util/elog.h>

using namespace std;
using namespace yyeva;
namespace yyeva {
    class RenderController {
    public:
        RenderController();

        ~RenderController();

        GLuint initRender(ANativeWindow *window, bool isNeedYUV, bool isNormalMp4);

        void destroyRender();

        void updateViewPoint(int width, int height);

        int getExternalTexture();

        void videoSizeChange(int newWidth, int newHeight);

        void setRenderConfig(shared_ptr<EvaAnimeConfig> config);

        void renderFrame();

        void renderSwapBuffers();

        void renderClearFrame();

        void releaseTexture();

        void mixConfigCreate(shared_ptr<EvaAnimeConfig> config);

        void mixRenderCreate();

        void mixRendering(int frameIndex);

        void mixRenderRelease(int textureId);

        void mixRenderDestroy();

        void parseFrame(shared_ptr<EvaAnimeConfig> config);

        void parseSrc(shared_ptr<EvaAnimeConfig> config);

#ifdef __OHOS__
        void setSrcBitmap(const char *srcId, unsigned char *bitmap, OH_NativeBuffer_Config *bitmapInfo,
                          string scaleMode);
#else
    void setSrcBitmap(const char *srcId, unsigned char *bitmap, AndroidBitmapInfo *bitmapInfo,
                          string scaleMode);
#endif

        void setSrcTxt(const char *srcId, const char *txt);

#ifdef __OHOS__
        void setBgImage(unsigned char *bitmap, OH_NativeBuffer_Config *bitmapInfo);
#else
        void setBgImage(unsigned char *bitmap, AndroidBitmapInfo *bitmapInfo);
#endif

        void setVideoRecord(bool videoRecord);

        void setBlendMode(int blendMode);

        GLuint getRecordFramebufferId();

        EGLContext getEglContext();

    private:
        shared_ptr<BgRender> bgRender;
        shared_ptr<IRender> render;
        shared_ptr<yyeva::FbRender> fbRender;
        shared_ptr<EvaMixRender> mixRender;
        shared_ptr<EvaAnimeConfig> config;
        int curFrameIndex;
        shared_ptr<EvaFrameAll> frameAll;
        shared_ptr<EvaSrcMap> srcMap;
        shared_ptr<EGLCore> eglCore;
        int width = 0;
        int height = 0;

        bool videoRecord = false;
        GLuint mFrameBuffer = -1;
        GLuint mFrameBufferTextures = -1;
        int mFrameWidth = -1;
        int mFrameHeight = -1;

        int blendMode = 1;

        void initRecordFrameBuffer(int width, int height);

        void destroyRecordFrameBuffer();
    };
}