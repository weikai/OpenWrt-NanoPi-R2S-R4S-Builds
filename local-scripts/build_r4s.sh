#!/bin/bash

ROOTDIR=$(readlink -e "$(dirname $0)/../")
BUILDDIR="$ROOTDIR/build"

cd $ROOTDIR

if [ ! -d "$ROOTDIR/steps" ]; then
    echo "Please move the script to a directory under the project root or into the steps directory."
    exit 1
fi

#[ ! -d $BUILDDIR ] && mkdir $BUILDDIR

# prepare or update code
if [ ! -d "$BUILDDIR/openwrt-fresh-2102" ]; then
  ./steps/01_clone_openwrt_2102.sh
else
  git -C "$BUILDDIR/openwrt-fresh-2102" pull
fi


if [ ! -d "$BUILDDIR/immortal-fresh-2102" ]; then
   ./steps/01_clone_immortalwrt_2102.sh
else
   git -C "$BUILDDIR/immortal-fresh-2102" pull
fi


echo -n "Step 02...\n------------------------------"
./steps/02_prepare_openwrt_folder_2102.sh

echo -n "Step 03...\n------------------------------"
./steps/r2s/03_patch_openwrt_2102.sh

echo -n "Step 04...\n------------------------------"
./steps/04-prepare_package.sh

echo -n "Step 05...\n------------------------------"
./steps/05-create_luci_acl.sh

echo -n "Step 06...\n------------------------------"
./steps/06-create_custom_config_from_seed.sh

if [ "$1" != 'setup-only' ]; then

cd $BUILDDIR/openwrt
make -j $(nproc)

fi


