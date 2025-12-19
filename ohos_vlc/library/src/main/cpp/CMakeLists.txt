# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(ohos_vlc)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(boundscheck)

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/thirdpart/include)

add_library(vlc_napi SHARED
    napi_init.cpp
    libvlc_wrapper.cpp
    media_player_wrapper.cpp
    media_wrapper.cpp
    xcomponent_manager.cpp
    common.cpp
    dialog_wrapper.cpp
    ohos_log.cpp)

target_link_libraries(vlc_napi PUBLIC
    ace_napi.z
    ace_ndk.z
    native_window
    hilog_ndk.z
    boundscheck
    EGL
    GLESv3
    ohaudio
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${OHOS_ARCH}/libvlc.so.5
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${OHOS_ARCH}/libvlccore.so.9
)
