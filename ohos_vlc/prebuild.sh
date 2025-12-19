#!/bin/bash

# Copyright (c) 2024 Huawei Device Co., Ltd.
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
API_VERSION=18                                                              # 三方库对应API版本，用于记录SDK路径,必须和"compileSdkVersion"字段表示的API版本保持一致
SDK_DIR=$OHOS_SDK_HOME/$API_VERSION               # SDK路径（流水线环境中SDK路径）
LYCIUM_TOOLS_URL=https://gitcode.com/openharmony-sig/tpc_c_cplusplus.git
LYCIUM_ROOT_DIR=$ROOT_DIR/tpc_c_cplusplus
LYCIUM_TOOLS_DIR=$LYCIUM_ROOT_DIR/lycium
LYCIUM_THIRDPARTY_DIR=$LYCIUM_ROOT_DIR/thirdparty
DEPENDS_DIR=$ROOT_DIR/Script                                                   # 依赖库编译脚本在仓库中的位置

DEPENDS_LIST=(
  a52dec
  aribb24
  gnutls
  libdca
  libidn2
  libtasn1
  libtheora
  nettle
  vlc
)

function prepare_lycium_tools()
{
    local commands=("gcc" "make" "cmake" "pkg-config" "autoconf" "autoreconf" "automake" "patch" "libtool" "autopoint" "gperf" \
    "tcl8.6-dev" "wget" "unzip" "gccgo-go" "flex " "bison" "premake4" "python3" "python3-pip" \
    "ninja-build" "meson" "sox" "gfortran" "subversion" "build-essential" "module-assistant" " gcc-multilib" \
    "g++-multilib" "libltdl7-dev" "cabextract" "libboost-all-dev" "libxml2-utils" "gettext" "libxml-libxml-perl" \
    "libxml2" "libxml2-dev" "libxml-parser-perl" "texinfo" "libtool-bin" "xmlto" "po4a" "yasm" "nasm" "xutils-dev" \
    "libx11-dev" "xtrans-dev" "gfortran-arm-linux-gnueabi" "gfortran-aarch64-linux-gnu")

    apt update >> /dev/null

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

function prepare_lycium()
{
    if [ -d $LYCIUM_ROOT_DIR ]
    then
        rm -rf $LYCIUM_ROOT_DIR
    fi

    git clone $LYCIUM_TOOLS_URL --depth=1
    if [ $? -ne 0 ]
    then
        return 1
    fi

    cd $LYCIUM_TOOLS_DIR/Buildtools
    tar -zxvf toolchain.tar.gz
    if [ $? -ne 0 ]
    then
        echo "unpack sdk toolchain failed!!"
        cd $OLDPWD
        return 1
    fi

    cp toolchain/* $SDK_DIR/native/llvm/bin/

    prepare_lycium_tools
    ret=$?
    cd $OLDPWD

    return $ret
}

function copy_depends()
{
    local dir="$1"
    local name="$2"

    if [ -d "$LYCIUM_THIRDPARTY_DIR/$name" ]
    then
        rm -rf "$LYCIUM_THIRDPARTY_DIR/$name"
    fi
    cp -arf "$dir/$name" "$LYCIUM_THIRDPARTY_DIR/"
}

function prepare_depends()
{
  for dep in "${DEPENDS_LIST[@]}"; do
      copy_depends "$DEPENDS_DIR" "$dep"
  done
}

function check_sdk()
{
    if [ ! -d $SDK_DIR ]
    then
        return 1
    fi

    export OHOS_SDK=$SDK_DIR
    return 0
}

function check_copy_shasum()
{
    local libpath=$1
    local pack_name=$2
    local libname=$3

    cd $LYCIUM_THIRDPARTY_DIR/$libpath
    if [ ! -f ./SHA512SUM ]
    then
        sha512sum $pack_name > ./SHA512SUM
    fi
    cp ./SHA512SUM $LYCIUM_TOOLS_DIR/usr/$libname/

    cd $OLDPWD
}

function install_shasum()
{
    return 0
}

function start_build()
{
    local result=0
    cd $LYCIUM_TOOLS_DIR
    if [ $? -ne 0 ]
    then
        return 1
    fi

    bash build.sh vlc
    result=$?
    cd $OLDPWD
    return $result
}

function install_depends()
{
    mkdir -p $ROOT_DIR/library/libs/arm64-v8a/
    local install_dir=$ROOT_DIR/library/libs/arm64-v8a/
    local src_dir=$LYCIUM_TOOLS_DIR/usr
    for pkg in "$src_dir"/*; do
        [ -d "$pkg" ] || continue
    
        arm64_lib="$pkg/arm64-v8a/lib"
    
        if [ -d "$arm64_lib" ]; then
            cp -arf "$arm64_lib"/* "$install_dir"
        fi
    done

    mkdir -p $ROOT_DIR/library/src/main/cpp/thirdpart/include/
    cp -arf $LYCIUM_TOOLS_DIR/usr/vlc/arm64-v8a/include/* $ROOT_DIR/library/src/main/cpp/thirdpart/include/
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
    prepare_lycium
    if [ $? -ne 0 ]
    then
        echo "ERROR: prepare_lycium failed!!!"
        return 1
    fi
    prepare_depends
    start_build
    if [ $? -ne 0 ]
    then
        echo "ERROR: start_build failed!!!"
        return 1
    fi
    install_depends
    if [ $? -ne 0 ]
    then
        echo "ERROR: install depends failed!!!"
        return 1
    fi
    echo "prebuild success!!"

    cd $ROOT_DIR
    git submodule update --init --recursive
    cd $OLDPWD

    return 0
}

prebuild $*
ret=$?
echo "ret = $ret"
exit $ret

#EOF
