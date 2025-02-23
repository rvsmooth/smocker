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
	if [ -f out/arch/arm64/boot/Image.gz-dtb ]; then
		cp out/arch/arm64/boot/Image.gz-dtb Anykernel
		cd Anykernel || exit
		zip -r9 "${ZIP_NAME}" anykernel.sh META-INF tools Image.gz-dtb
		/toolchain/bin/tg-upload.sh *.zip
	else
		echo "KERNEL BUILD FAILED"
		exit 1
	fi
    else
	    echo "Anykernel not found"
	    exit 1
fi
