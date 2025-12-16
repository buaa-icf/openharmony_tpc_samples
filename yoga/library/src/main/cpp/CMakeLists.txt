# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(yoga_native)
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG")
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wno-error=unused-command-line-argument)
endif()

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/yoga/yoga ${CMAKE_CURRENT_BINARY_DIR}/yoga EXCLUDE_FROM_ALL)
if(CMAKE_BUILD_TYPE STREQUAL "Release")
  target_compile_options(yogacore PRIVATE $<$<CONFIG:RELEASE>:-O3>)
endif()
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

if(${CMAKE_BUILD_TYPE} STREQUAL "Release")
    target_link_options(yoga_native PRIVATE -s)
    add_compile_options(-O3)
    add_compile_options(
        -flto
        -fwhole-program-vtables
        "SHELL:-mllvm --enable-partial-inlining"
    )
    add_link_options(
        -flto
        -Wl,-mllvm,-wholeprogramdevirt-check=fallback
        -Wl,-mllvm,--enable-partial-inlining
        -Wl,-mllvm,--tail-dup-placement
    )
endif()
