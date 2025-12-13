# Copyright (c) Huawei Technologies Co., Ltd. 2023. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.5.0)
project(ohos_rive VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")
set(CMAKE_VERBOSE_MAKEFILE ON)

add_library(ohos_rive SHARED
            napi_init.cpp
           src/helpers/general.cpp
           src/helpers/factories.cpp
           src/helpers/font_helper.cpp
           src/helpers/resource.cpp
           src/refs.cpp
           src/helpers/thread.cpp
           src/helpers/thread_state_egl.cpp
           src/helpers/thread_state_pls.cpp
           src/helpers/worker_thread.cpp
           src/helpers/worker_ref.cpp
           src/helpers/exception_handler.cpp
           src/helpers/image_decode.cpp
           src/helpers/canvas_render_objects.cpp
           src/models/dimensions_helper.cpp
           src/models/file_asset_loader.cpp
           src/models/canvas_renderer.cpp
           src/models/renderer.cpp
           src/models/worker_impl.cpp
           src/bindings/bindings_file_asset_loader.cpp
           src/bindings/bindings_font.cpp
           src/bindings/bindings_init.cpp
           src/bindings/bindings_file.cpp
           src/bindings/bindings_bindable_artboard.cpp
           src/bindings/bindings_artboard.cpp
           src/bindings/bindings_data_binding.cpp
           src/bindings/bindings_rive_texture_view.cpp
           src/bindings/bindings_helper.cpp
           src/bindings/bindings_linear_animation_instance.cpp
	       src/bindings/bindings_renderer.cpp
           src/bindings/bindings_state_machine_input_instance.cpp
           src/bindings/bindings_state_machine_instance.cpp
           src/bindings/bindings_layer_state.cpp
           src/bindings/bindings_file_asset.cpp
           src/bindings/bindings_text_value_run.cpp
           src/bindings/bindings_rive_event.cpp
           src/bindings/bindings_command_queue_egl.cpp
           src/bindings/bindings_command_queue.cpp
           )
target_link_libraries(ohos_rive PUBLIC libace_napi.z.so)

# List of static libraries
set(static_libs
        rive
        rive_harfbuzz
        rive_sheenbidi
        rive_yoga
        rive_pls_renderer
)

# Enable C++17
target_compile_features(ohos_rive PUBLIC cxx_std_17)
target_compile_options(ohos_rive PRIVATE
        -Wall # Enable all warnings
        -fno-exceptions # Disable C++ exceptions
        -fno-rtti # Disable C++ RTTI
        $<$<CONFIG:Release>:-Oz>) # Optimize for size with -Oz in release
target_compile_definitions(ohos_rive PUBLIC LOG)
# Configure for monorepo vs. ohos_rive repo
if (EXISTS "${PROJECT_SOURCE_DIR}/../../../../submodules/rive-runtime")
    set(PACKAGES_DIR "${PROJECT_SOURCE_DIR}/../../../../")
    set(RIVE_RUNTIME_DIR "${PACKAGES_DIR}/submodules/rive-runtime")
else ()
    message(FATAL_ERROR "rive-runtime not found at expected location: ${PROJECT_SOURCE_DIR}/../../../../submodules/rive-runtime")
endif ()
set(ENV{RIVE_RUNTIME_DIR} "${RIVE_RUNTIME_DIR}")
# Add an option to remove miniaudio
# Passed from Gradle with -DWITH_RIVE_AUDIO=ON|OFF
option(WITH_RIVE_AUDIO "Enable Rive audio support" ON)
if (WITH_RIVE_AUDIO)
    # Compile flag picked up by JNI C++
    target_compile_definitions(ohos_rive PRIVATE
            WITH_RIVE_AUDIO
            MA_NO_RESOURCE_MANAGER)
    # Value for Premake --with_rive_audio
    set(RIVE_AUDIO_ARG "system")
    # Add to the list of static libraries
    list(APPEND static_libs miniaudio)
else ()
    # Value for Premake --with_rive_audio
    set(RIVE_AUDIO_ARG "disabled")
endif ()

# Add an option to enable ASAN
# Passed from Gradle with -DENABLE_ASAN=ON|OFF
option(ENABLE_ASAN "Enable Address Sanitizer" OFF)
if (ENABLE_ASAN)
    # Pass to Premake to enable ASAN on librive and its dependencies
    set(RIVE_ASAN_FLAG "--with-asan")

    # Add ASAN flags to ohos_rive as well
    target_compile_options(ohos_rive PRIVATE
            -fsanitize=address
            -fno-omit-frame-pointer)
    target_link_options(ohos_rive PRIVATE
            -fsanitize=address
            -Wl,--export-dynamic
            -Wl,--no-undefined)
endif ()

# Debug/release configuration
message("BUILD TYPE: ${CMAKE_BUILD_TYPE}")
#[[ CMake adds these flags depending on CMAKE_BUILD_TYPE
    1. Debug: `-O0 -g`
    2. Release: `-O3 -DNDEBUG`
    3. RelWithDebInfo: `-O2 -g -DNDEBUG`
    4. MinSizeRel: `-Os -DNDEBUG`
]]
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CONFIG "debug")
elseif (CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CONFIG "release")
endif ()

if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64" OR CMAKE_ANDROID_ARCH_ABI STREQUAL "arm64-v8a")
    set(RIVE_ARCH "arm64")
    message("Building for ARM64 architecture")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "armv7|arm" OR CMAKE_ANDROID_ARCH_ABI STREQUAL "armeabi-v7a")
    set(RIVE_ARCH "arm")
    message("Building for ARM architecture")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64" OR CMAKE_ANDROID_ARCH_ABI STREQUAL "x86_64")
    set(RIVE_ARCH "x64")
    message("Building for x64 architecture")
else()
    set(RIVE_ARCH "x64")
    message("Building for x64 architecture")
endif()

if(DEFINED ENV{OHOS_NDK})
    set(OHOS_NDK_PATH $ENV{OHOS_NDK})
    message("Using OHOS_NDK from environment: ${OHOS_NDK_PATH}")
elseif(DEFINED ENV{OHOS_SDK_HOME})
    set(API_VERSION 12)
    set(SDK_DIR $ENV{OHOS_SDK_HOME}/${API_VERSION})
    set(OHOS_NDK_PATH ${SDK_DIR}/native)
    message("Using OHOS_NDK from OHOS_SDK_HOME: ${OHOS_NDK_PATH}")
else()
    message(FATAL_ERROR "OpenHarmony NDK not found. Please set OHOS_NDK or OHOS_SDK_HOME environment variable.")
endif()

if(NOT EXISTS ${OHOS_NDK_PATH})
    message(FATAL_ERROR "OHOS NDK path does not exist: ${OHOS_NDK_PATH}")
endif()

if(CMAKE_HOST_WIN32)
    set(CLANG_PATH "${OHOS_NDK_PATH}/llvm/bin/clang++.exe")
else()
    set(CLANG_PATH "${OHOS_NDK_PATH}/llvm/bin/clang++")
endif()
if(EXISTS ${CLANG_PATH})
    message("Found clang++ at: ${CLANG_PATH}")
else()
    message(FATAL_ERROR "clang++ not found at expected location: ${CLANG_PATH}")
endif()

# Build the Rive C++ runtime and its dependencies as static .a libs
# Execute build script with platform-specific handling
if(CMAKE_HOST_WIN32)
    # Windows: Execute .bat file directly
    execute_process(
            COMMAND ${RIVE_RUNTIME_DIR}/build/build_rive.bat --file=./premake5_cpp_runtime.lua ohos ninja ${CONFIG} ${RIVE_ARCH} --no-rive-decoders --with_rive_audio=${RIVE_AUDIO_ARG} ${RIVE_ASAN_FLAG} -- rive_cpp_runtime
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            RESULT_VARIABLE SCRIPT_RESULT
            OUTPUT_VARIABLE SCRIPT_OUTPUT
            ECHO_OUTPUT_VARIABLE
    )
else()
set(TOOLS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/tools")
# set(BUILD_ENV "PATH=$ENV{PATH}:${TOOLS_DIR} OHOS_NDK=${OHOS_NDK_PATH}")
# macOS/Linux: Execute shell script directly
# set(SCRIPT_CMD "${BUILD_ENV} ${RIVE_RUNTIME_DIR}/build/build_rive.sh --file=./premake5_cpp_runtime.lua ohos ninja ${CONFIG} ${RIVE_ARCH} --with_rive_audio=${RIVE_AUDIO_ARG} ${RIVE_ASAN_FLAG} --no-rive-decoders -- rive_cpp_runtime")
execute_process(
    COMMAND 
        bash -c "
            export PATH=\"\$PATH:${TOOLS_DIR}\"
            export OHOS_NDK=\"${OHOS_NDK_PATH}\"
            ${RIVE_RUNTIME_DIR}/build/build_rive.sh \
                --file=./premake5_cpp_runtime.lua \
                ohos ninja ${CONFIG} ${RIVE_ARCH} \
                --no-rive-decoders --with_rive_audio=${RIVE_AUDIO_ARG} ${RIVE_ASAN_FLAG} \
                -- rive_cpp_runtime
        "
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    RESULT_VARIABLE SCRIPT_RESULT
    OUTPUT_VARIABLE SCRIPT_OUTPUT
    ECHO_OUTPUT_VARIABLE
)
endif()
if (NOT SCRIPT_RESULT EQUAL "0")
    message(FATAL_ERROR "Script returned with error: '${SCRIPT_OUTPUT}' - '${SCRIPT_RESULT}'")
endif ()


# Add header files
target_include_directories(ohos_rive PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${RIVE_RUNTIME_DIR}/include
        ${RIVE_RUNTIME_DIR}/renderer/include)

# Link each static library
foreach (X IN LISTS static_libs)
    set(LIB_TARGET "${X}-lib")
    add_library(${LIB_TARGET} STATIC IMPORTED)

    set(LIB_PATH "${CMAKE_CURRENT_SOURCE_DIR}/out/${RIVE_ARCH}_${CONFIG}/lib${X}.a")
    message("Linking library ${X} from: ${LIB_PATH}")

    if(EXISTS ${LIB_PATH})
        set_target_properties(${LIB_TARGET}
                PROPERTIES IMPORTED_LOCATION
                ${LIB_PATH}
        )
        target_link_libraries(ohos_rive PUBLIC ${LIB_TARGET})
        message("Successfully linked ${X} for ohos/${RIVE_ARCH}")
    else()
        message(WARNING "Library not found: ${LIB_PATH} - skipping")
    endif()
endforeach ()

# Find additional libraries
find_library(log-lib libhilog_ndk.z.so)
find_library(egl-lib libEGL.so)
find_library(gles-lib libGLESv3.so)
find_library(hitrace-lib libhitrace_ndk.z.so)
find_library(pixelmap-lib libpixelmap_ndk.z.so)
find_library(native_drawing libnative_drawing.so)
find_library(image_source libimage_source.so)
find_library(pixelmap libpixelmap.so)
find_library(native_window libnative_window.so)

# Link additional libraries
target_link_libraries(ohos_rive PUBLIC
        ${log-lib}
        ${egl-lib}
        ${gles-lib}
        ${hitrace-lib}
        ${pixelmap-lib}
        ${native_drawing}
        ${image_source}
        ${pixelmap}
        ${native_window}
)