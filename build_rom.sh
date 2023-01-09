#!/bin/bash

set -e
set -x

# sync rom
repo init -u https://github.com/PixelExperience/manifest -b thirteen
git clone https://github.com/rombuilder/local_manifest-1 --depth 1 -b main .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
breakfast aosp_holi-user
croot
brunch aosp_huli -j$(nproc --all)

# upload rom
up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/holi/*.zip 
up out/target/product/holi/boot.img
