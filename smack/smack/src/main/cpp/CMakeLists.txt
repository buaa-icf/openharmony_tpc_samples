# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(XComponent)

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