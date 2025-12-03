# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(vlc-harmony-test)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

set(AKI_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules/@ohos/aki) # 设置AKI根路径
set(CMAKE_MODULE_PATH ${AKI_ROOT_PATH})
find_package(Aki REQUIRED)

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

file(GLOB RENDER_SRC ${CMAKE_CURRENT_SOURCE_DIR}/render/*.cpp)

add_library(entry SHARED napi_init.cpp vlc_media_wrapper.cpp vlc_wrapper.cpp vlc_media_player_wrapper.cpp ${RENDER_SRC})
target_link_libraries(entry PUBLIC libace_napi.z.so ace_ndk.z EGL GLESv3 libohaudio.so libnative_window.so ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${OHOS_ARCH}/libvlc.so Aki::libjsbind)
#target_link_libraries(entry PUBLIC libace_napi.z.so Aki::libjsbind)
target_include_directories(entry PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(entry PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/render)