cmake_minimum_required(VERSION 3.26)
project(ohos_utils)

option(USE_HILOG "Enable hilog" ON)
option(USE_LIBUV "Enable libuv" ON)

aux_source_directory(./ UTILS_SRC)

if (USE_HILOG)
  add_definitions(-DOHOS_LOG_ON)
endif()

add_library(${PROJECT_NAME} ${UTILS_SRC})
target_include_directories(${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../>
)
target_link_libraries(${PROJECT_NAME} PRIVATE ace_napi.z)
if (USE_HILOG)
  target_link_libraries(${PROJECT_NAME} PRIVATE hilog_ndk.z)
endif()
if (USE_LIBUV)
  add_definitions(-DOHOS_USE_LIBUV)
  target_link_libraries(${PROJECT_NAME} PRIVATE uv)
endif()