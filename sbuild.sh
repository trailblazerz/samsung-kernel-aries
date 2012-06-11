#!/bin/bash

START=$(date +%s)

sema_ver="Semaphore_ICS_1.2.2s_Vibrant"

export KBUILD_BUILD_VERSION="10"
export LOCALVERSION="-"`echo $sema_ver`

make CROSS_COMPILE=/home/juston/CM9/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- ARCH=arm vibrant_sema_defconfig

make CROSS_COMPILE=/home/juston/CM9/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- ARCH=arm -j8 modules

find /home/juston/CM9 -name '*.ko' -exec cp -v {} /home/juston/CM9/kernel/samsung/stock/ics-ramdisk/ics_combo/files/modules \;

make CROSS_COMPILE=/home/juston/CM9/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- ARCH=arm -j8 zImage

cd arch/arm/boot
tar cvf `echo $sema_ver`.tar zImage
mv $sema_ver.tar /home/juston/CM9/kernel/samsung/stock/ics-ramdisk
cd ../../../

cp arch/arm/boot/zImage /home/juston/CM9/kernel/samsung/stock/ics-ramdisk/cwm/boot.img

cd /home/juston/CM9/kernel/samsung/stock/ics-ramdisk/cwm

zip -r `echo $sema_ver`.zip *

mv  `echo $sema_ver`.zip ../

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Time Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC
