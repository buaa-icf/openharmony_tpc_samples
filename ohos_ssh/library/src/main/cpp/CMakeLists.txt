# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(ssh_ohos_napi)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(ssh_ohos_napi SHARED
            napi/napi_init.cpp
            napi/keygen2.cpp
            napi/ssh2_client.cpp
            napi/ssh2_napi.cpp
            napi/ssh2_server.cpp
            utils/log/ohos_log.cpp
            utils/napi/napi_utils.cpp)

target_include_directories(ssh_ohos_napi PUBLIC ${NATIVERENDER_ROOT_PATH}/thirdparty/openssl/${OHOS_ARCH}/include)
target_include_directories(ssh_ohos_napi PUBLIC ${NATIVERENDER_ROOT_PATH}/thirdparty/libssh/${OHOS_ARCH}/include)

target_link_libraries(ssh_ohos_napi PUBLIC libace_napi.z.so hilog_ndk.z uv)
target_link_libraries(ssh_ohos_napi PUBLIC ${NATIVERENDER_ROOT_PATH}/thirdparty/libssh/${OHOS_ARCH}/lib/libssh.so.4)
target_link_libraries(ssh_ohos_napi PUBLIC ${NATIVERENDER_ROOT_PATH}/thirdparty/openssl/${OHOS_ARCH}/lib/libcrypto.so.3)
target_link_libraries(ssh_ohos_napi PUBLIC ${NATIVERENDER_ROOT_PATH}/thirdparty/openssl/${OHOS_ARCH}/lib/libssl.so.3)