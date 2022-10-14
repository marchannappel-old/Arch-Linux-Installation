# Installation Arch

- [ ] Step 1: Set Keyboard Layout to de: ```> loadkeys de-latin1```
- [ ] Step 2: Set time synchronization active: ```> timedatectl set-ntp true```
- [ ] Step 3: Set the timezone to Europe/Berlin: ```> timedatectl set-timezone Europe/Berlin```
- [ ] Step 4: Partition your hard disks: 

```bash
> fdisk -l
> fdisk /dev/sda
> m => opens help menu
> g => creates a new GPT table (only EFI), otherwise choose o (DOS table)
> m
> n => creates a new partition
> 1
> [Enter]
> +550m (creates a EFI partition of 550MB)
> n
> 2
> [Enter]
> +2G (creates an Swap Partition of 2GB)
> n
> 3
> [Enter]
> [Enter]
> t => changes partition type
> 1
> 1 [Enter] => changes partition type to EFI
> t
> 2
> 19 [Enter] => changes partition type to Linux Swap
> w => Write changes to disk
```

- [ ] Step 5: Create Filesystems: 

```bash
> mkfs.fat -F32 /dev/sda1 [Enter] => changes EFI system to FAT32
> mkswap /dev/sda2 [Enter] => changes Filesystem to swap
> swapon /dev/sda2 => activates swap
> mkfs.ext4 /dev/sda3 => changes Filesystem to ExFAT4
#> mount --mkdir /dev/sda1 /mnt/boot => mounts the EFI partition to /mnt/boot
> mount /dev/sda3 /mnt => mounts the main filesystem to /mnt
```

- [ ] Step 6: Install Essential OS packages:

```bash
> pacstrap -K /mnt base linux-lts linux-firmware
```

<!-- 
TODO: consider other packages, might be done later in chroot:
- userspace utilities
- more firmware
- networking software
- a texteditor = nano
-->

- [ ] Step 7: Create filesystem tables (Fstab)

```bash
> genfstab -U /mnt >> /mnt/etc/fstab
```

- [ ] Step 8: go to arch root and set-up Localization:

```bash
> arch-chroot /mnt
> pacman -S nano
> nano /etc/locale.gen => uncomment de_DE.UTF-8 UTF-8 STRG+O -> STRG+X
>locale-gen
```

- [ ] Step 9: Set hostname: cyber-linux

```bash
> nano /etc/hostname
```

<!--
TODO: nano /etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.0.1    cyberpunk.localdomain  cyberpunk
 -->

- [ ] Step 10: Create Users and setup root account:

```bash
> passwd => type password [Enter] -> verify password [Enter]
> useradd -m euburos
> passwd eoburos
> usermod -aG wheel,audio,video,optical,storage eoburos
> pacman -S sudo
> EDITOR=nano visudo => uncomment %wheel .... and save
```

- [ ] Step 11: Install grub boot loader:

```bash
> pacman -S grub
> pacman -S efibootmgr dosfstools os-prober mtools
> mkdir /boot/EFI
> mount /dev/sda1 /boot/EFI
> grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
> grub-mkconfig -o /boot/grub/grub.cfg
```

- [ ] Step 12: Install Network manager

```bash
> pacman -S networkmanager
> systemctl enable NetworkManager
> exit
```

- [ ] Step 13: Prepare Reboot

```bash
> umount /mnt
```