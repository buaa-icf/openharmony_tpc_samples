# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(luaarkts)


set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDENUG")
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDENUG")
set(TARGET_NAME luaarkts)


if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

set(AKI_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules/@ohos/aki) # 设置AKI根路径
set(CMAKE_MODULE_PATH ${AKI_ROOT_PATH})
find_package(Aki REQUIRED)

add_library(luaarkts SHARED napi_init.cpp napi_arkts.cpp napi_lua.cpp)

if(${CMAKE_BUILD_TYPE} STREQUAL "Release")
    target_link_options(${TARGET_NAME} PRIVATE -s)
    set(LTO_FLAG "-flto=thin")
    add_compile_options(-O3 -march=native)
    target_compile_options(${TARGET_NAME} PRIVATE ${LTO_FLAG})
    target_link_options(${TARGET_NAME} PRIVATE ${LTO_FLAG})
endif()

target_link_libraries(luaarkts PUBLIC Aki::libjsbind) # 链接二进制依赖 & 头文件
target_link_libraries(luaarkts PUBLIC libace_napi.z.so)
target_link_libraries(luaarkts PUBLIC libhilog_ndk.z.so)

target_include_directories(luaarkts PRIVATE  ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/lua/${OHOS_ARCH}/include)
target_link_libraries(luaarkts PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/lua/${OHOS_ARCH}/lib/liblua.a)

#add_subdirectory(aki)
#target_link_libraries(luaarkts PUBLIC aki_jsbind)



