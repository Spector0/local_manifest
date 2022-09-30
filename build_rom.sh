#!/bin/bash

set -e
set -x

# sync rom
repo init -u https://github.com/LineageOS/android.git -b lineage-19.1
git clone https://github.com/Spector0/local_manifest --depth 1 -b main .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
breakfast lineage_oscar-user
croot
brunch lineage_oscar -j$(nproc --all)

# upload rom
up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/oscar/*.zip 
up out/target/product/oscar/boot.img
