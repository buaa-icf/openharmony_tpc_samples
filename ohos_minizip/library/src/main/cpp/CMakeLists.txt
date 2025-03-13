# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(minizip_ng)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(THIRDPARTY_PATH ${CMAKE_CURRENT_SOURCE_DIR}/third_party)
set(MINIZIP_ADAPTER_PATH ${CMAKE_CURRENT_SOURCE_DIR}/minizipAdapter)
set(AKI_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules/@ohos/aki) # 设置AKI根路径
set(CMAKE_MODULE_PATH ${AKI_ROOT_PATH})
find_package(Aki REQUIRED)

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    ${THIRDPARTY_PATH}/bzip2/${OHOS_ARCH}/include
                    ${THIRDPARTY_PATH}/googletest/${OHOS_ARCH}/include/gmock
                    ${THIRDPARTY_PATH}/googletest/${OHOS_ARCH}/include/gtest
                    ${THIRDPARTY_PATH}/minizip-ng/${OHOS_ARCH}/include/minizip
                    ${THIRDPARTY_PATH}/openssl/${OHOS_ARCH}/include/openssl
                    ${THIRDPARTY_PATH}/xz/${OHOS_ARCH}/include/lzma
                    ${THIRDPARTY_PATH}/xz/${OHOS_ARCH}/include
                    ${THIRDPARTY_PATH}/zstd/${OHOS_ARCH}/include)

add_library(minizip_ng SHARED ${MINIZIP_ADAPTER_PATH}/minizipNative.cpp
                              ${MINIZIP_ADAPTER_PATH}/minizipCompressNative.cpp)

target_link_libraries(minizip_ng PUBLIC libace_napi.z.so libhilog_ndk.z.so -s -ftrapv)
target_link_libraries(minizip_ng PUBLIC Aki::libjsbind) # 链接二进制依赖 & 头文件
target_link_libraries(minizip_ng PUBLIC ${THIRDPARTY_PATH}/minizip-ng/${OHOS_ARCH}/lib/libminizip.a)
target_link_libraries(minizip_ng PUBLIC ${THIRDPARTY_PATH}/bzip2/${OHOS_ARCH}/lib/libbz2.a)
target_link_libraries(minizip_ng PUBLIC ${THIRDPARTY_PATH}/openssl/${OHOS_ARCH}/lib/libcrypto.a)
target_link_libraries(minizip_ng PUBLIC ${THIRDPARTY_PATH}/openssl/${OHOS_ARCH}/lib/libssl.a)
target_link_libraries(minizip_ng PUBLIC ${THIRDPARTY_PATH}/xz/${OHOS_ARCH}/lib/liblzma.a)
target_link_libraries(minizip_ng PUBLIC ${THIRDPARTY_PATH}/zstd/${OHOS_ARCH}/lib/libzstd.a)
target_link_libraries(minizip_ng PUBLIC ${THIRDPARTY_PATH}/zlib/${OHOS_ARCH}/lib/libz.a)


