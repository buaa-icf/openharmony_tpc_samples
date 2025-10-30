# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(yoga_native)

file(GLOB_RECURSE SOURCES_ROOT
    ${CMAKE_CURRENT_SOURCE_DIR}/core/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/napi_init.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/yoga_napi.cpp
)

add_library(yoga_native SHARED ${SOURCES_ROOT})

target_include_directories(yoga_native PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/core
    ${CMAKE_CURRENT_SOURCE_DIR}/utils
)

target_link_libraries(yoga_native PUBLIC libace_napi.z.so libc++_shared.so libhilog_ndk.z.so)

#将三方库加入工程中
target_link_libraries(yoga_native PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/yoga/${OHOS_ARCH}/lib/libyogacore.a)
#将三方库的头文件加入工程中
target_include_directories(yoga_native PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/yoga/${OHOS_ARCH}/include)
