# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(myNpmLib)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    ${NATIVERENDER_ROOT_PATH}/common
                    ${NATIVERENDER_ROOT_PATH}/pjsip
                    ${NATIVERENDER_ROOT_PATH}/pjsip/util
                    ${NATIVERENDER_ROOT_PATH}/pjsip/log
                    ${NATIVERENDER_ROOT_PATH}/pjsip/account
                    ${NATIVERENDER_ROOT_PATH}/pjsip/unwrap
                    ${NATIVERENDER_ROOT_PATH}/pjsip/listener
                    )

add_library(ohos_pjsip SHARED
                        napi_init.cpp
                        common/napi_helper.cpp
                        pjsip/pjsip_app.cpp
                        pjsip/account/pjsip_account.cpp
                        pjsip/account/pjsip_call.cpp
                        pjsip/unwrap/build_class.cpp
                        )

target_include_directories(ohos_pjsip PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/pjsip/${OHOS_ARCH}/include/)
# 设置对应的配置项
target_compile_definitions(ohos_pjsip PUBLIC -DPJ_AUTOCONF=1  -DPJ_IS_BIG_ENDIAN=0 -DPJ_IS_LITTLE_ENDIAN=1)

# 将三方库加入工程中
target_link_directories(ohos_pjsip PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/pjsip/${OHOS_ARCH}/lib)

if(${OHOS_ARCH} STREQUAL "arm64-v8a")
  target_link_libraries(ohos_pjsip PUBLIC pjsua2-aarch64-unknown-linux-gnu pjsua-aarch64-unknown-linux-gnu pjsip-ua-aarch64-unknown-linux-gnu
        pjsip-simple-aarch64-unknown-linux-gnu pjsip-aarch64-unknown-linux-gnu pjmedia-codec-aarch64-unknown-linux-gnu pjmedia-aarch64-unknown-linux-gnu
        pjmedia-videodev-aarch64-unknown-linux-gnu pjmedia-audiodev-aarch64-unknown-linux-gnu pjmedia-aarch64-unknown-linux-gnu pjnath-aarch64-unknown-linux-gnu
        pjlib-util-aarch64-unknown-linux-gnu pj-aarch64-unknown-linux-gnu srtp-aarch64-unknown-linux-gnu resample-aarch64-unknown-linux-gnu
        gsmcodec-aarch64-unknown-linux-gnu speex-aarch64-unknown-linux-gnu ilbccodec-aarch64-unknown-linux-gnu g7221codec-aarch64-unknown-linux-gnu
        yuv-aarch64-unknown-linux-gnu)
elseif(${OHOS_ARCH} STREQUAL "armeabi-v7a")
  target_link_libraries(ohos_pjsip PUBLIC pjsua2-arm-unknown-linux-gnu pjsua-arm-unknown-linux-gnu pjsip-ua-arm-unknown-linux-gnu
        pjsip-simple-arm-unknown-linux-gnu pjsip-arm-unknown-linux-gnu pjmedia-codec-arm-unknown-linux-gnu pjmedia-arm-unknown-linux-gnu
        pjmedia-videodev-arm-unknown-linux-gnu pjmedia-audiodev-arm-unknown-linux-gnu pjmedia-arm-unknown-linux-gnu pjnath-arm-unknown-linux-gnu
        pjlib-util-arm-unknown-linux-gnu pj-arm-unknown-linux-gnu srtp-arm-unknown-linux-gnu resample-arm-unknown-linux-gnu
        gsmcodec-arm-unknown-linux-gnu speex-arm-unknown-linux-gnu ilbccodec-arm-unknown-linux-gnu g7221codec-arm-unknown-linux-gnu
        yuv-arm-unknown-linux-gnu)

#if(${OHOS_ARCH} STREQUAL "arm64-v8a")
#  target_link_libraries(ohos_pjsip PUBLIC g7221codec gsmcodec ilbccodec
#        pj pjlib-util pjmedia pjmedia-audiodev
#        pjmedia-codec pjmedia-videodev pjnath pjsip
#        pjsip-simple pjsip-ua pjsua pjsua2
#        resample speex srtp yuv)

else()
  message("not support Architecture")
endif()

target_link_libraries(ohos_pjsip PUBLIC libace_napi.z.so
                                   libace_ndk.z.so native_window EGL GLESv3
                                   libhilog_ndk.z.so uv ohaudio ohcamera image_receiver native_image ohimage native_buffer hilog_ndk.z
                                   native_media_codecbase native_media_core native_media_vdec c++_shared native_media_venc)
