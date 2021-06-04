#!/bin/bash
ROOTDIR=$(pwd)
echo $ROOTDIR
if [ ! -e "$ROOTDIR/build" ]; then
    echo "Please run from root / no build dir"
    exit 1
fi

cd "$ROOTDIR/build"

cd openwrt
cp $ROOTDIR/seed/weikai.seed .config
patch .config < $ROOTDIR/seed/subnet.patch
make defconfig
cp .config  weikai.config
