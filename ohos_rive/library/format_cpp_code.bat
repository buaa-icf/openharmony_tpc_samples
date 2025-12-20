REM Copyright (C) 2025 Huawei Device Co., Ltd.
REM Licensed under the Apache License, Version 2.0 (the "License");
REM you may not use this file except in compliance with the License.
REM You may obtain a copy of the License at
REM
REM     http://www.apache.org/licenses/LICENSE-2.0
REM
REM Unless required by applicable law or agreed to in writing, software
REM distributed under the License is distributed on an "AS IS" BASIS,
REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM See the License for the specific language governing permissions and
REM limitations under the License.

@echo off

REM Check if clang-format is available
where clang-format > nul
if %errorlevel% neq 0 (
    echo Error: clang-format not found. Please install LLVM tools first.
    echo Download from: https://llvm.org/builds/
    pause
    exit /b 1
)

REM Display clang-format version information
clang-format --version

REM Set target directory
set CPP_DIR=.\src\main\cpp
set CLANG_FORMAT_FILE=%CPP_DIR%\.clang-format

REM Check if .clang-format configuration file exists
if not exist "%CLANG_FORMAT_FILE%" (
    echo Warning: Cannot find %CLANG_FORMAT_FILE%. Using default configuration.
)

REM Format specific directories and file
set CPP_BASE=.\src\main\cpp
set INCLUDE_DIR=%CPP_BASE%\include
set SRC_DIR=%CPP_BASE%\src
set NAPI_FILE=%CPP_BASE%\napi_init.cpp

REM Format .cpp and .h files in include directory
echo Formatting files in %INCLUDE_DIR%
for /r "%INCLUDE_DIR%" %%f in (*.cpp *.h) do (
    REM Skip thread_state_pls.h to preserve include order
    if not "%%~nf%%~xf" == "thread_state_pls.h" (
        echo Formatting: %%f
        clang-format -i "%%f"
    ) else (
        echo Skipping: %%f (preserving include order)
    )
)

REM Format .cpp and .h files in src directory
echo Formatting files in %SRC_DIR%
for /r "%SRC_DIR%" %%f in (*.cpp *.h) do (
    echo Formatting: %%f
    clang-format -i "%%f"
)

REM Format the specific napi_init.cpp file
if exist "%NAPI_FILE%" (
    echo Formatting specific file: %NAPI_FILE%
    clang-format -i "%NAPI_FILE%"
) else (
    echo Warning: %NAPI_FILE% not found!
)

echo Formatting completed!
pause