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
API_VERSION=12                                                              # 三方库对应API版本，用于记录SDK路径,必须和"compileSdkVersion"字段表示的API版本保持一致
SDK_DIR=$ROOT_DIR/../ohos-sdk-$API_VERSION/linux/$API_VERSION               # SDK路径（流水线环境中SDK路径）
LYCIUM_TOOLS_URL=https://gitcode.com/openharmony-sig/tpc_c_cplusplus.git
LYCIUM_ROOT_DIR=$ROOT_DIR/tpc_c_cplusplus
LYCIUM_TOOLS_DIR=$LYCIUM_ROOT_DIR/lycium
LYCIUM_THIRDPARTY_DIR=$LYCIUM_ROOT_DIR/thirdparty
DEPENDS_DIR=$ROOT_DIR/doc                                                   # 依赖库编译脚本在仓库中的位置                                                  # FFmpeg的依赖库名，需和依赖库一起安装

CI_OUTPUT_DIR=$ROOT_DIR/../out/tpc/                                  # hap/har安装目录

LIBS_NAME=("openssl")
PACKAGE_NAME=("openssl-OpenSSL_1_1_1u.zip")

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

    git clone $LYCIUM_TOOLS_URL -b master --depth=1
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
    local dir=$1
    local name=$2

    if [ -d $dir/$name ]
    then
        cp -arf $dir/$name $LYCIUM_THIRDPARTY_DIR/
    fi
}

function prepare_depends()
{
    for libname in ${LIBS_NAME[@]}
    do
        copy_depends $DEPENDS_DIR $libname
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
    indices=(${!LIBS_NAME[@]})

    for i in "${indices[@]}"; do
        libname="${LIBS_NAME[i]}"
        package="${PACKAGE_NAME[i]}"
        check_copy_shasum $libname ${package} $libname
    done
}
function start_build()
{
    local result=0
    cd $LYCIUM_TOOLS_DIR
    if [ $? -ne 0 ]
    then
        return 1
    fi
    bash build.sh "${LIBS_NAME[@]}"
    result=$?
    cd $OLDPWD
    return $result
}

function copy_lib()
{
    local src_dir=$1
    local dst_dir=$2
    arches=("arm64-v8a" "armeabi-v7a" "x86_64")
    for arch in ${arches[@]}
    do
        if [ ! -d $dst_dir/$arch ];then
            mkdir -p $dst_dir/$arch
        fi
        cp -af $src_dir/$arch/lib/libssl.a $dst_dir/$arch/
        cp -af $src_dir/$arch/lib/libcrypto.a $dst_dir/$arch/
    done
}

function install_depends()
{
    local xlog_dir=$(pwd)/library/src/main/cpp/external/openssl_lib_ohos

    for libname in ${LIBS_NAME[@]}
    do
        copy_lib $LYCIUM_TOOLS_DIR/usr/$libname $xlog_dir
        if [ $? -ne 0 ]
        then
            echo "${libname} build failed!"
            return 1
        fi
        if [ -d $CI_OUTPUT_DIR ]
        then
            cp -arf $LYCIUM_TOOLS_DIR/usr/$libname $CI_OUTPUT_DIR
        fi
    done
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
    install_shasum
    install_depends
    if [ $? -ne 0 ]
    then
        echo "ERROR: install depends failed!!!"
        return 1
    fi
    echo "prebuild success!!"

    return 0
}

prebuild $*
ret=$?
echo "ret = $ret"
exit $ret

#EOF
