#!/bin/bash

TOOL_PATH=$PORT_ROOT/tools/
BOOTNAME=$1
BASEBOOTNAME=`basename $1`
BOOTIMAGE_PATH=`dirname $1`

function unpackbootimg() {
    rm -rf $BOOTIMAGE_PATH/unpack
    rm -rf $BOOTIMAGE_PATH/boot

    mkdir $BOOTIMAGE_PATH/unpack
    $TOOL_PATH/unpackbootimg -i "$BOOTNAME" -o $BOOTIMAGE_PATH/unpack

    mkdir $BOOTIMAGE_PATH/boot
    cp $BOOTIMAGE_PATH/unpack/"$BASEBOOTNAME"-ramdisk.gz $BOOTIMAGE_PATH/boot/
    cd $BOOTIMAGE_PATH/boot

    gzip -dc "$BASEBOOTNAME"-ramdisk.gz | cpio -i
    rm -f $BOOTIMAGE_PATH/boot/"$BASEBOOTNAME"-ramdisk.gz
    cd -

}

function repackbootimg() {
    rm -rf $BOOTIMAGE_PATH/target_img
    rm -f $BOOTIMAGE_PATH/unpack/boot.img-ramdisk.gz
    mkdir $BOOTIMAGE_PATH/target_img
    #For Stock Kernel
    $TOOL_PATH/mkbootfs boot | gzip > $BOOTIMAGE_PATH/unpack/boot.img-ramdisk.gz

    #Repack boot.img
    $TOOL_PATH/mkbootimg --kernel $BOOTIMAGE_PATH/unpack/kernel \
    --ramdisk $BOOTIMAGE_PATH/unpack/boot.img-ramdisk.gz \
    -o $BOOTIMAGE_PATH/target_img/boot.img --base `cat $BOOTIMAGE_PATH/unpack/boot.img-base` \
    --cmdline "`cat $BOOTIMAGE_PATH/unpack/boot.img-cmdline`" \
    --pagesize `cat $BOOTIMAGE_PATH/unpack/boot.img-pagesize` \
    --ramdiskaddr `cat $BOOTIMAGE_PATH/unpack/boot.img-ramdiskaddr`
}

function patch_bootimage() {
    sed -i 's/services.jar/services.jar:\/system\/framework\/lewa-framework.jar/g' $BOOTIMAGE_PATH/boot/init.rc
    sed -i 's/ro\.secure=.*/ro\.secure=0/' $BOOTIMAGE_PATH/boot/default.prop
}

if [ -n "$1" ]; then
    unpackbootimg
    patch_bootimage
    repackbootimg
    cp -f $BOOTIMAGE_PATH/target_img/boot.img $BOOTIMAGE_PATH/
    rm -rf $BOOTIMAGE_PATH/target_img
    rm -rf $BOOTIMAGE_PATH/boot
    rm -rf $BOOTIMAGE_PATH/unpack
fi
