#!/bin/bash


git clone "${ANYKERNEL_URL}" Anykernel 

make -j$(nproc) O=out ARCH="${ARCH}" "${DEFCONFIG}"
make -j$(nproc) O=out \
                ARCH=arm64 \
                CC=clang \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                CROSS_COMPILE=aarch64-linux-android- \
                CROSS_COMPILE_ARM32=arm-linux-androideabi- \
                AR=llvm-ar \
		NM=llvm-nm \
		OBJCOPY=llvm-objcopy \
		OBJDUMP=llvm-objdump \
		STRIP=llvm-strip

if [ -d Anykernel ]; then 
	    zip -r9 "${ZIP_NAME}" anykernel.sh META-INF tools version Image.gz-dtb
	    /toolchain/bin/tg-upload.sh Anykernel/*.zip
    else
	    echo "Anykernel not found"
	    exit 1
fi
