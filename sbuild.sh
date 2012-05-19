#!/bin/bash

sema_ver="Semaphore_ICS_1.2.0s_Vibrant_CFS"

#export KBUILD_BUILD_VERSION="2"
export LOCALVERSION="-"`echo $sema_ver`

#make CROSS_COMPILE=/home/juston/CM9/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- ARCH=arm aries_vibrantmtd_defconfig
#make CROSS_COMPILE=/opt/toolchains/android-toolchain-eabi-12.01/bin/arm-eabi- ARCH=arm -j4
#make CROSS_COMPILE=/opt/toolchains/arm-2009q3/bin/arm-none-linux-gnueabi- ARCH=arm -j4
make CROSS_COMPILE=/home/juston/CM9/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- ARCH=arm -j8 modules


#find /kernels/samsung-kernel-aries/ -name '*.ko' -exec cp -v {} /kernels/ics-ramdisk/cwm/system/lib/modules \;
find /home/juston/CM9 -name '*.ko' -exec cp -v {} /home/juston/CM9/kernel/samsung/stock/ics-ramdisk/ics_combo/files/modules \;

make CROSS_COMPILE=/home/juston/CM9/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- ARCH=arm -j8 zImage

cp arch/arm/boot/zImage /home/juston/CM9/kernel/samsung/stock/ics-ramdisk/cwm/boot.img

cd /home/juston/CM9/kernel/samsung/stock/ics-ramdisk/cwm

zip -r `echo $sema_ver`.zip *

mv  `echo $sema_ver`.zip ../


