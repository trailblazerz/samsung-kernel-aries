#!/bin/bash

START=$(date +%s)

BASE_SEMA_VER="Semaphore_JB_2.1.1"

case "$1" in
        galaxys)
            VARIANT="galaxys"
            VER=""
            ;;

        captivate)
            VARIANT="captivate"
            VER="c"
            ;;

        vibrant)
            VARIANT="vibrant"
            VER="v"
            ;;

        *)
            VARIANT="galaxys"
            VER=""
esac

if [ "$2" = "s" ] ; then
	BASE_SEMA_VER=$BASE_SEMA_VER"s"
fi

SEMA_VER=$BASE_SEMA_VER$VER

export KBUILD_BUILD_VERSION="1"
export LOCALVERSION="-"`echo $SEMA_VER`
#export CROSS_COMPILE=/opt/toolchains/gcc-linaro-arm-linux-gnueabihf-2012.07-20120720_linux/bin/arm-linux-gnueabihf-
export CROSS_COMPILE=/home/juston/cm10/gcc-linaro-arm-linux-gnueabihf-2012.08-20120827_linux/bin/arm-linux-gnueabihf-
export ARCH=arm

eval $(grep CONFIG_INITRAMFS_SOURCE .config)
INIT_DIR=$CONFIG_INITRAMFS_SOURCE
MODULES_DIR=/home/juston/cm10/kernel/ics-ramdisk/jb_combo_v/files/modules
KERNEL_DIR=`pwd`
OUTPUT_DIR=/home/juston/cm10/kernel/output
CWM_DIR=/home/juston/cm10/kernel/ics-ramdisk/cwm/

echo "LOCALVERSION="$LOCALVERSION
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH
echo "INIT_DIR="$INIT_DIR
echo "MODULES_DIR="$MODULES_DIR
echo "KERNEL_DIR="$KERNEL_DIR
echo "OUTPUT_DIR="$OUTPUT_DIR
echo "CWM_DIR="$CWM_DIR

echo 
echo "Making ""semaphore"_$VARIANT"_defconfig"

make "semaphore"_$VARIANT"_defconfig"

if [ "$2" = "s" ] ; then
        echo "CONFIG_S5P_HUGEMEM=y" >> .config
fi


make -j8 modules

rm `echo $MODULES_DIR"/*"`
find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;

make -j8 zImage

cd arch/arm/boot
tar cvf `echo $SEMA_VER`.tar zImage
mv `echo $SEMA_VER`.tar $OUTPUT_DIR$VARIANT
echo "Moving to "$OUTPUT_DIR$VARIANT"/"
cd ../../..

cp arch/arm/boot/zImage $CWM_DIR"boot.img"
cd $CWM_DIR
zip -r `echo $SEMA_VER`.zip *
mv  `echo $SEMA_VER`.zip $OUTPUT_DIR$VARIANT"/"

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Time Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC

