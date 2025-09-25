# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(pdfium)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

set(AKI_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules/@ohos/aki) # 设置AKI根路径
set(CMAKE_MODULE_PATH ${AKI_ROOT_PATH})
find_package(Aki REQUIRED)

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

include_directories(${NATIVERENDER_ROOT_PATH}/thirdparty/pdfium/pdfium)
include_directories(${NATIVERENDER_ROOT_PATH}/thirdparty/pdfium/pdfium/cpp)

add_library(entry SHARED napi_init.cpp pdfiumwrapper/pdfium.cpp pdfiumwrapper/pdfiumpage.cpp)

target_link_libraries(entry PRIVATE ${NATIVERENDER_ROOT_PATH}/thirdparty/pdfium/libs/${OHOS_ARCH}/libchrome_zlib.cr.so)
target_link_libraries(entry PRIVATE ${NATIVERENDER_ROOT_PATH}/thirdparty/pdfium/libs/${OHOS_ARCH}/libicuuc.cr.so)
target_link_libraries(entry PRIVATE ${NATIVERENDER_ROOT_PATH}/thirdparty/pdfium/libs/${OHOS_ARCH}/libpdfium.cr.so)
target_link_libraries(entry PRIVATE ${NATIVERENDER_ROOT_PATH}/thirdparty/pdfium/libs/${OHOS_ARCH}/libthird_party_abseil-cpp_absl.cr.so)

target_link_libraries(entry PUBLIC libace_napi.z.so libhilog_ndk.z.so Aki::libjsbind libpixelmap_ndk.z.so)