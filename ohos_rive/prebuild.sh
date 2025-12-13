#!/bin/bash

# Copyright (c) 2025 Huawei Device Co., Ltd.
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

# 执行该脚本时需进入到脚本所在目录
ROOT_DIR=$(pwd)
API_VERSION=12
SDK_DIR=$OHOS_SDK_HOME/$API_VERSION

function prepare_tools()
{
    local commands=("make" "cmake" "automake" "python3" "python3-pip" "python3-ply")
    local local_premake5="$ROOT_DIR/library/src/main/cpp/tools/premake5"

    apt update >> /dev/null

    # 优先处理premake5 - 先尝试使用本地版本
    if [ -f "$local_premake5" ]; then
        echo "Found local premake5 at $local_premake5"
        # 为本地premake5设置执行权限
        chmod +x "$local_premake5"
    else
        # 本地premake5不存在时，安装系统版本
        which premake5 >> /dev/null
        if [ $? -ne 0 ]; then
            echo "install premake5"
            apt install premake5 -y >> /dev/null
        fi
    fi

    # 安装其他必要工具
    for cmd in ${commands[@]}
    do
        which $cmd >> /dev/null
        if [ $? -ne 0 ]
        then
            echo "install $cmd"
            apt install $cmd -y >> /dev/null
        fi
    done
}

function check_sdk()
{
    if [ ! -d $SDK_DIR ]
    then
        echo "Can not find ${SDK_DIR}"
        return 1
    fi

    export OHOS_SDK=$SDK_DIR
    export OHOS_NDK=$SDK_DIR/native
    return 0
}

function prebuild()
{
    check_sdk
    if [ $? -ne 0 ]
    then
        echo "ERROR: check_sdk failed!!!"
        return 1
    fi
    prepare_tools
    if [ $? -ne 0 ]
    then
        echo "ERROR: prepare_tools failed!!!"
        return 1
    fi
    cd $ROOT_DIR
    git submodule update --init --recursive submodules/rive-runtime
    cd $OLDPWD
    return 0
}

prebuild $*
ret=$?
echo "ret = $ret"
exit $ret

#EOF
