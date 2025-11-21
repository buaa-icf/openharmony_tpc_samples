//
// Created by zengjiale on 2022/4/21.
//
#pragma once
#include <GLES3/gl3.h>
#include <GLES2/gl2ext.h>
#ifdef __OHOS__
#include <ohos/ohos_window.h>
#else
#include <android/bitmap.h>
#endif
#include <util/stb_image_write.h>
#include <bean/evasrc.h>
#include <EGL/egl.h>
#include <util/elog.h>

class TextureLoadUtil {
public:
#ifndef __OHOS__
    static GLuint loadTexture(unsigned char* bitmap, AndroidBitmapInfo* info);
#else
    static GLuint loadTexture(unsigned char* bitmap, OH_NativeBuffer_Config* info);
#endif
    static GLuint loadTexture(shared_ptr<EvaSrc> src);
    static void releaseTexture(GLuint textureId);
};

