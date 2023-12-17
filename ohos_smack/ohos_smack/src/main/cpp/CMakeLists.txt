# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(XComponent)

# 判断操作系统类型
if(${CMAKE_HOST_SYSTEM_NAME} MATCHES "Windows")
    # 如果是 Windows,请手动打patch.
    message("The current operating system is: Windows.Please insert patch manually")
elseif(${CMAKE_HOST_SYSTEM_NAME} MATCHES "Linux")
    # 如果是 Linux
    message("The current operating system is: Linux")
    add_custom_command(
        OUTPUT out.c
        COMMAND touch out.c
        COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/thirdModule/
        COMMAND bash modify.sh
        VERBATIM)

    add_library(test SHARED out.c)
else()
    message(FATAL_ERROR "Unsupported operating system type")
endif()

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
aux_source_directory(gloox/src SOUCE_FILES)
include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    gloox
                    )

add_library(entry SHARED
		hello.cpp
		log_ohos.cpp
		Smack.cpp
		room.cpp
		registration.cpp
		MyMUCInvitationHandler.cpp
		${SOUCE_FILES})

target_link_libraries(entry PUBLIC libace_napi.z.so libc++.a libhilog_ndk.z.so)