# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(ohos_oh7zip)
set(CMAKE_CXX_STANDARD 17)

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

if (NOT CMAKE_BUILD_TYPE)
set(CMAKE_BUILD_TYPE "Debug")
endif()

set(CMAKE_SKIP_RPATH TRUE)

add_library(oh7zip SHARED napi_init.cpp
                          uncompress/uncompress.cpp
                          uncompress/uncompress_bridge.cpp
                          compress/compress.cpp
                          compress/compress_bridge.cpp
                          napi_help/napi_help.cpp
                          task_pool/task_pool.cpp)

target_link_libraries(oh7zip PUBLIC libace_napi.z.so libffrt.z.so)
target_link_libraries(oh7zip PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${OHOS_ARCH}/lib7zz.so)
target_include_directories(oh7zip PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
                                         ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_link_libraries(oh7zip PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/minizip-ng/${OHOS_ARCH}/lib/libminizip.a)
target_link_libraries(oh7zip PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/bzip2/${OHOS_ARCH}/lib/libbz2.a)
target_link_libraries(oh7zip PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/openssl/${OHOS_ARCH}/lib/libcrypto.a)
target_link_libraries(oh7zip PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/xz/${OHOS_ARCH}/lib/liblzma.a)
target_link_libraries(oh7zip PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zstd/${OHOS_ARCH}/lib/libzstd.a)
target_link_libraries(oh7zip PUBLIC z)
target_include_directories(oh7zip PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/bzip2/${OHOS_ARCH}/include
                                         ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/openssl/${OHOS_ARCH}/include
                                         ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/xz/${OHOS_ARCH}/include
                                         ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zstd/${OHOS_ARCH}/include
                                         ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/minizip-ng/${OHOS_ARCH}/include/minizip)


target_compile_definitions(oh7zip PUBLIC -DNAPI_VERSION=16)
target_compile_options(oh7zip PUBLIC -fvisibility=hidden)
if(CMAKE_BUILD_TYPE STREQUAL "Release")
target_link_options(oh7zip PRIVATE -s)
target_link_libraries(oh7zip PRIVATE "-Wl,--version-script=${CMAKE_CURRENT_SOURCE_DIR}/oh7zip.expmap")
endif()
add_custom_command(TARGET oh7zip POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_CURRENT_SOURCE_DIR}/../../../include
)