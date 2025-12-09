# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(vlc-harmony-test)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(boundscheck)

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(vlc_napi SHARED napi_init.cpp vlc_wrapper.cpp vlc_media_player_wrapper.cpp vlc_media_wrapper.cpp xcomponent_manager.cpp ohos_log.cpp)
target_link_libraries(vlc_napi PUBLIC
    ace_napi.z
    ace_ndk.z
    native_window
    hilog_ndk.z
    boundscheck
    EGL
    GLESv3
    libohaudio.so
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${OHOS_ARCH}/libvlc.so.5
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${OHOS_ARCH}/libvlccore.so.9
)
target_include_directories(vlc_napi PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
