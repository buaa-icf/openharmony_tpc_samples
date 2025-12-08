# CMakeLists.txt for Spine Harmony Runtime
cmake_minimum_required(VERSION 3.5.0)
project(spine_harmony)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(boundscheck)

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

# 头文件目录
include_directories(
    ${NATIVERENDER_ROOT_PATH}
    ${NATIVERENDER_ROOT_PATH}/thirdparty/spinec/include
    ${NATIVERENDER_ROOT_PATH}/thirdparty/spinec/spine
    ${NATIVERENDER_ROOT_PATH}/thirdparty/stb
    ${NATIVERENDER_ROOT_PATH}/boundscheck/third_party_bounds_checking_function/include
    ${NATIVERENDER_ROOT_PATH}/boundscheck/third_party_bounds_checking_function/src
)

# spine-c 源文件
file(GLOB SPINE_C_SOURCES
    ${NATIVERENDER_ROOT_PATH}/thirdparty/spinec/spine/*.c
)

# spine-harmony 源文件
set(SPINE_HARMONY_SOURCES
    ${NATIVERENDER_ROOT_PATH}/spine_extension.cpp
    ${NATIVERENDER_ROOT_PATH}/spine_renderer.cpp
    ${NATIVERENDER_ROOT_PATH}/spine_instance.cpp
    ${NATIVERENDER_ROOT_PATH}/spine_napi.cpp
)

# 创建共享库
add_library(spine SHARED
    ${SPINE_C_SOURCES}
    ${SPINE_HARMONY_SOURCES}
)

# 链接系统库
target_link_libraries(spine PUBLIC
    libace_napi.z.so
    libace_ndk.z.so
    libhilog_ndk.z.so
    librawfile.z.so
    libEGL.so
    libGLESv3.so
    libnative_window.so
    boundscheck
)

# C 编译选项
set_source_files_properties(${SPINE_C_SOURCES} PROPERTIES
    COMPILE_FLAGS "-std=c99"
)

# C++ 编译选项
target_compile_options(spine PRIVATE
    -fPIC
    -Wall
    -Wno-unused-variable
    -Wno-unused-function
)

# 定义宏
target_compile_definitions(spine PRIVATE
    SPINE_SHORT_NAMES
)