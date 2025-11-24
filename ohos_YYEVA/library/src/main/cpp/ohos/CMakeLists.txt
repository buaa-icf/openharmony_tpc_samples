cmake_minimum_required(VERSION 3.26)
project(ohos_utils)

option(USE_HILOG "Enable hilog" ON)
option(USE_LIBUV "Enable libuv" ON)

set(UTILS_SRC
  napi_handler.cpp
  napi_async_handler.cpp
  napi_wrapper.cpp
  ohos_window.cpp
  )

if (USE_HILOG)
  add_definitions(-DOHOS_LOG_ON)
  list(APPEND UTILS_SRC ohos_log.cpp)
endif()

add_library(${PROJECT_NAME} ${UTILS_SRC} napi_object.cpp)
target_include_directories(${PROJECT_NAME} PRIVATE .)
target_link_libraries(${PROJECT_NAME} PRIVATE ace_napi.z libpixelmap_ndk.z.so libimage_source_ndk.z.so )
if (USE_HILOG)
  target_link_libraries(${PROJECT_NAME} PRIVATE hilog_ndk.z)
endif()
if (USE_LIBUV)
  add_definitions(-DOHOS_USE_LIBUV)
  target_link_libraries(${PROJECT_NAME} PRIVATE uv)
endif()