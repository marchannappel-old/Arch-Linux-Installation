##!/bin/bash

build_keyboard

checkNet

echo "Disk partitioning, what should I partition?[EFI, BIOS]"
read DEVICE_SYSTEM
if [[ -z "$DEVICE_SYSTEM"]]; then
    echo "Please choose one of the available system types"
elif [[ "$DEVICE_SYSTEM" == "EFI" ]]; then
    partitionDiskEFI

    createFsEFI
elif [[ "$DEVICE_SYSTEM" == "BIOS" ]]; then
    partitionDiskBIOS

    createFsBIOS
else
    partitionDiskEFI

    createFsEFI
fi