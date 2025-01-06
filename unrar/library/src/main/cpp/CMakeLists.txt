# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(myNpmLib)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/third_party/unrar/${OHOS_ARCH}/include)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DLITTLE_ENDIAN")

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fvisibility=hidden")

add_library(unrar SHARED unrar.cpp)
target_link_libraries(unrar PUBLIC libace_napi.z.so libhilog_ndk.z.so)
target_link_libraries(unrar PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/third_party/unrar/${OHOS_ARCH}/lib/libshard_unrar.so)
