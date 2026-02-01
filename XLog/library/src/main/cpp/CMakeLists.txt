
cmake_minimum_required(VERSION 3.5.0)
project(xlog_napi)

set(PATCH_SCRIPT_COMM "${CMAKE_CURRENT_SOURCE_DIR}/external/xlog_comm.patch")

if(EXISTS ${PATCH_SCRIPT_COMM})
    execute_process(
        COMMAND git apply --ignore-whitespace ${PATCH_SCRIPT_COMM}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/mars
        RESULT_VARIABLE patch_result
        OUTPUT_VARIABLE patch_output
        ERROR_VARIABLE patch_error
    )

    if(patch_result EQUAL 1)
        message(STATUS "Mars patch applied successfully")
    else()
        message(STATUS "apply patch: ${patch_error}")
    endif()
endif()

set(PATCH_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/external/xlog_ohos.patch")

if(EXISTS ${PATCH_SCRIPT})
    execute_process(
        COMMAND git apply --ignore-whitespace ${PATCH_SCRIPT}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/mars
        RESULT_VARIABLE patch_result
        OUTPUT_VARIABLE patch_output
        ERROR_VARIABLE patch_error
    )

    if(patch_result EQUAL 1)
        message(STATUS "Mars patch applied successfully")
    else()
        message(STATUS "apply patch: ${patch_error}")
    endif()
endif()

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/external/openssl_lib_ohos
     DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/mars/openssl
     NO_SOURCE_PERMISSIONS)

add_definitions(-DOHOS_LOG_TAG=\"xlog_napi\")
add_definitions(-DOHOS_LOG_ON)
add_definitions(-DOHOS)
add_subdirectory(ohos_utils)

set(OHOS_ABI ${OHOS_ARCH})

if(NOT MSVC)
    set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".so" ".a")
endif()
find_library(CRYPT_LIB crypto PATHS mars/openssl/openssl_lib_ohos/${OHOS_ABI} NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
find_library(SSL_LIB ssl PATHS mars/openssl/openssl_lib_ohos/${OHOS_ABI} NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)

add_subdirectory(mars/comm comm)
add_subdirectory(mars/boost boost)
add_subdirectory(mars/log log)

#for zlib
aux_source_directory(mars/openssl/UWP/zlib ZLIB_SRC_FILES)

# for zstd
set(ZSTD_BUILD_STATIC ON CACHE BOOL "BUILD STATIC LIBRARIES" FORCE)
set(ZSTD_BUILD_SHARED OFF CACHE BOOL "BUILD SHARED LIBRARIES" FORCE)
set(ZSTD_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/mars/zstd")
set(LIBRARY_DIR ${ZSTD_SOURCE_DIR}/lib)
include(GNUInstallDirs)
add_subdirectory(${ZSTD_SOURCE_DIR}/build/cmake/lib zstd)

aux_source_directory(. SRC_XLOG_NAPI)
add_library(xlog_napi SHARED ${SRC_XLOG_NAPI} ${ZLIB_SRC_FILES})
target_link_libraries(xlog_napi PUBLIC
    libace_napi.z.so ohos_utils xlog
    libzstd_static
    comm mars-boost
    ${CRYPT_LIB}
    ${SSL_LIB}
    )
target_include_directories(xlog_napi PRIVATE ./ mars/log mars/comm/xlogger)
