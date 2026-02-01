# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
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

cmake_minimum_required(VERSION 3.5)

set(can_use_assembler TRUE)
enable_language(ASM)
IF("${OHOS_ARCH}" STREQUAL "arm64-v8a")
 SET(ASM_OPTIONS "-x assembler-with-cpp")
 SET(CMAKE_ASM_FLAGS "${CFLAGS} ${ASM_OPTIONS} -march=armv8+crypto -D__OHOS__")
ENDIF()

project(boundscheck)

set(TAGET_BOUNDSCHECK_SRC_PATH ${CMAKE_CURRENT_SOURCE_DIR}/third_party_bounds_checking_function/src)

add_library(boundscheck
            STATIC
            ${TAGET_BOUNDSCHECK_SRC_PATH}/memcpy_s.c
            ${TAGET_BOUNDSCHECK_SRC_PATH}/memset_s.c
            ${TAGET_BOUNDSCHECK_SRC_PATH}/securecutil.c
            ${TAGET_BOUNDSCHECK_SRC_PATH}/vsnprintf_s.c
            ${TAGET_BOUNDSCHECK_SRC_PATH}/secureprintoutput_a.c)

include_directories(${TAGET_BOUNDSCHECK_SRC_PATH}
                    ${CMAKE_CURRENT_SOURCE_DIR}/third_party_bounds_checking_function/include
                    )

target_link_libraries(boundscheck)

target_include_directories(boundscheck PUBLIC
    ${TAGET_BOUNDSCHECK_SRC_PATH}
    ${CMAKE_CURRENT_SOURCE_DIR}/third_party_bounds_checking_function/include
)