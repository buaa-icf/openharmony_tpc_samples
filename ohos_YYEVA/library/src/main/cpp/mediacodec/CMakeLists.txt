# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(videoCodecSample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

add_definitions(-DOHOS_LOG_TAG=\"mediacodec\")

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/capbilities/include
                    ${NATIVERENDER_ROOT_PATH}/common
                    ${NATIVERENDER_ROOT_PATH}/common/dfx/err
                    ${NATIVERENDER_ROOT_PATH}/common/dfx/log
                    ${NATIVERENDER_ROOT_PATH}/render/include
)

set(BASE_LIBRARY
    libace_napi.z.so libGLESv3.so libace_ndk.z.so libuv.so libhilog_ndk.z.so
    libnative_media_codecbase.so libnative_media_core.so libnative_media_vdec.so libnative_window.so
    libnative_media_venc.so libnative_media_acodec.so libnative_media_avdemuxer.so libnative_media_avsource.so libnative_media_avmuxer.so
    libohaudio.so  libnative_image.so
)
#add_subdirectory(../ohos ohos_utils)
aux_source_directory(napi src_NAPI)
add_library(mediacodec SHARED ${src_NAPI}
                          capbilities/demuxer.cpp
                          capbilities/video_decoder.cpp
                          capbilities/audio_decoder.cpp
                          common/sample_callback.cpp
)

target_link_libraries(mediacodec PUBLIC ${BASE_LIBRARY} ohos_utils)
target_include_directories(mediacodec PRIVATE ../)