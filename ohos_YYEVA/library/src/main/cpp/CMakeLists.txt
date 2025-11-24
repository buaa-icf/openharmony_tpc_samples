# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5)
project(yyeva)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-int-conversion -Wl,-Bsymbolic")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-int-conversion -Wl,-Bsymbolic")
set(CMAKE_SKIP_RPATH TRUE)

add_definitions(-DOHOS_PLATFORM -D__OHOS__)
if (NOT CMAKE_BUILD_TYPE)
set(CMAKE_BUILD_TYPE "Debug")
endif()

add_definitions(-DOHOS_LOG_TAG=\"yyevac\")
add_subdirectory(ohos)
add_subdirectory(mediacodec)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/bean bean_SRC)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/egl egl_SRC)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/engine engine_SRC)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/mix mix_SRC)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/record record_SRC)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/util util_SRC)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/napi napi_SRC)

add_library(yyeva_napi SHARED ${bean_SRC} ${egl_SRC} ${engine_SRC} ${mix_SRC} ${record_SRC} ${napi_SRC} ${util_SRC})
target_link_libraries(yyeva_napi PUBLIC ohos_utils GLESv3 EGL hilog_ndk.z ace_napi.z  libace_ndk.z.so libpixelmap_ndk.z.so libpixelmap.so libnative_window.so)
target_include_directories(yyeva_napi PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/../../../)
target_compile_options(yyeva_napi PRIVATE -Wno-changes-meaning -Wno-int-conversion)
