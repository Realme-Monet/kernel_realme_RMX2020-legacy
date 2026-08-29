#!/bin/bash

SECONDS=0 # builtin bash timer

function compile() 
{

source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
export ARCH=arm64
export KBUILD_BUILD_HOST=android-build
export KBUILD_BUILD_USER="dp02xd"

wget https://github.com/yhnu/op7t/releases/download/v1.0/clang-r487747c.tar.gz -O "aosp-clang.tar.gz"
mkdir clang && tar -xf aosp-clang.tar.gz -C clang && rm -rf aosp-clang.tar.gz

curl -LSs "https://raw.githubusercontent.com/backslashxx/KernelSU/refs/heads/master/kernel/setup.sh" | bash

[ -d "out" ] && rm -rf out || mkdir -p out
make O=out ARCH=arm64 RMX2020_defconfig

PATH="${PWD}/clang/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      CC="clang" \
                      LLVM=1 \
                      LLVM_IAS=1 \
                      CONFIG_NO_ERROR_ON_MISMATCH=y
}

function zipping()
{
rm -rf AnyKernel
git clone --depth=1 https://github.com/realme-monet/AnyKernel3.git AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
ZIPNAME="AETHER.XXKSU.MONET.$(date '+%d%m%Y%H%M').zip"
zip -r9 "../$ZIPNAME" *
}

compile
zipping
