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
API_VERSION=12                                                              # 三方库对应API版本，用于记录SDK路径,必须和"compileSdkVersion"字段表示的API版本保持一致
SDK_DIR=$ROOT_DIR/../../ohos-sdk-$API_VERSION/linux/$API_VERSION               # SDK路径（流水线环境中SDK路径）
LYCIUM_TOOLS_URL=https://gitcode.com/openharmony-sig/tpc_c_cplusplus.git
LYCIUM_ROOT_DIR=$ROOT_DIR/tpc_c_cplusplus
LYCIUM_TOOLS_DIR=$LYCIUM_ROOT_DIR/lycium
LYCIUM_THIRDPARTY_DIR=$LYCIUM_ROOT_DIR/thirdparty
LYCIUM_COMMUNITY_DIR=$LYCIUM_ROOT_DIR/community
DEPENDS_DIR=$ROOT_DIR/doc                                                   # 依赖库编译脚本在仓库中的位置
BZIP2_NAME=bzip2_1_0_8                                                      # 依赖库名
MINIZIP_NAME=minizip-ng                                                     # 依赖库名
OPENSSL_NAME=openssl                                                        # 依赖库名
XZ_NAME=xz                                                                  # 依赖库名
ZSTD_NAME=zstd                                                              # 依赖库名
# ZLIB_NAME=zlib_1_3_1                                                        # 依赖库名
CI_OUTPUT_DIR=$ROOT_DIR/../out/tpc/                                         # hap/har安装目录

LIBS_NAME=("zlib_1_3_1" "minizip-ng" "openssl" "xz" "zstd")
PACKAGE_NAME=("zlib-v1.3.1.zip" "minizip-ng-4.0.0.tar.gz" "openssl-OpenSSL_1_1_1u.zip" "xz-v5.4.1.zip" "facebook-zstd-v1.5.4.zip")

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
    local dir=$1
    local name=$2

    if [ -d $LYCIUM_THIRDPARTY_DIR/$name ]
    then
        rm -rf $LYCIUM_THIRDPARTY_DIR/$name
    fi
    cp -arf $dir/$name $LYCIUM_THIRDPARTY_DIR/
}

function prepare_depends()
{
    copy_depends $LYCIUM_COMMUNITY_DIR $MINIZIP_NAME
    copy_depends $LYCIUM_COMMUNITY_DIR $XZ_NAME
    copy_depends $LYCIUM_COMMUNITY_DIR $BZIP2_NAME
    # copy_depends $LYCIUM_COMMUNITY_DIR $ZLIB_NAME
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
    # check_copy_shasum $ZLIB_NAME ${PACKAGE_NAME[0]} $ZLIB_NAME
    check_copy_shasum $MINIZIP_NAME ${PACKAGE_NAME[1]} $MINIZIP_NAME
    check_copy_shasum $OPENSSL_NAME ${PACKAGE_NAME[2]} $OPENSSL_NAME  
    check_copy_shasum $XZ_NAME ${PACKAGE_NAME[3]} $XZ_NAME
    check_copy_shasum $ZSTD_NAME ${PACKAGE_NAME[4]} $ZSTD_NAME
}
function start_build()
{
    local result=0
    cd $LYCIUM_TOOLS_DIR
    if [ $? -ne 0 ]
    then
        return 1
    fi

    bash build.sh $BZIP2_NAME $MINIZIP_NAME $OPENSSL_NAME $XZ_NAME $ZSTD_NAME 
    result=$?
    cd $OLDPWD
    return $result
}

function install_depends()
{
    local install_dir=$ROOT_DIR/library/src/main/cpp/thirdparty/
    mkdir $ROOT_DIR/library/src/main/cpp/thirdparty
    cp -arf $LYCIUM_TOOLS_DIR/usr/$BZIP2_NAME $install_dir/bzip2
    if [ $? -ne 0 ]
    then
        echo "bzip2 build failed!"
        return 1
    fi
    cp -arf $LYCIUM_TOOLS_DIR/usr/$MINIZIP_NAME $install_dir/minizip-ng
    if [ $? -ne 0 ]
    then
        echo "minizip-ng build failed!"
        return 1
    fi
    cp -arf $LYCIUM_TOOLS_DIR/usr/$OPENSSL_NAME $install_dir/openssl
    if [ $? -ne 0 ]
    then
        echo "openssl build failed!"
        return 1
    fi
    cp -arf $LYCIUM_TOOLS_DIR/usr/$XZ_NAME $install_dir/xz
    if [ $? -ne 0 ]
    then
        echo "xz build failed!"
        return 1
    fi
    cp -arf $LYCIUM_TOOLS_DIR/usr/$ZSTD_NAME $install_dir/zstd
    if [ $? -ne 0 ]
    then
        echo "zstd build failed!"
        return 1
    fi

    if [ -d $CI_OUTPUT_DIR ]
    then
        cp -arf $LYCIUM_TOOLS_DIR/usr/$BZIP2_NAME $CI_OUTPUT_DIR
        cp -arf $LYCIUM_TOOLS_DIR/usr/$MINIZIP_NAME $CI_OUTPUT_DIR
        cp -arf $LYCIUM_TOOLS_DIR/usr/$OPENSSL_NAME $CI_OUTPUT_DIR
        cp -arf $LYCIUM_TOOLS_DIR/usr/$XZ_NAME $CI_OUTPUT_DIR
        cp -arf $LYCIUM_TOOLS_DIR/usr/$ZSTD_NAME $CI_OUTPUT_DIR
    fi
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

    return 0
}

prebuild $*
ret=$?
echo "ret = $ret"
exit $ret

#EOF