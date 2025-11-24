# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(yoga_native)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wno-error=unused-command-line-argument)
endif()

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/yoga/yoga ${CMAKE_CURRENT_BINARY_DIR}/yoga EXCLUDE_FROM_ALL)

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
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/yoga
)

target_link_libraries(yoga_native PUBLIC libace_napi.z.so libc++_shared.so libhilog_ndk.z.so yogacore)