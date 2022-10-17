# Installation Arch

## 1.  Tastatur Layout anpassen
```bash
> loadkeys de-latin1
```

## 2. Internetverbindung prüfen
```bash
> ping google.com
```

**Keine Internetverbindung:**

1. Lan:
```bash
> ip link
```

2. WLan:
```bash
> iwctl
> station wlan0 connect <SSID>
```
*Verlassen der Shell STRG+D oder exit*

## 3. Festplatten partitionieren

### UEFI
Systeme die auf UEFI laufen sollten immer mit gdisk partitioniert werden.
Partitionen:
1. /boot: 512MB groß vom Typ ef00
2. /root: Restliche größe
3. swap: atleast RAM size, type 8200 (optional)

**/boot Partition:**

```bash
> gdisk /dev/sda
> o
> y

> n
> ENTER
> ENTER
> +512M
> ef00
```

**swap Partition (optional):**
```bash
> n
> ENTER
> +32G # Je nach RAM größe anderer Wert !
> 8200
```

**/root Partition:**
```bash
> n
> ENTER
> ENTER
> ENTER
> ENTER 
```

**Write to Disk:**
```bash
> p
> w
> y
```

## 4. Anlegen der Dateisysteme
```bash
> mkfs.fat -F 32 -n BOOT /dev/sda1
> mkfs.ext4 -L Root /dev/sda2
> mkswap -L SWAP /dev/sda3 #(optional)
```

## 5. Basissystem installieren

**1 . Partitionen einbinden:**
```bash
> mount -L ROOT /mnt
> mkdir /mnt/boot
> mount -L BOOT /mnt/boot
> swapon -L SWAP #(optional)
```

**2. Installation der Basispakete:**

a) Intel Prozessoren
```bash
> pacstrap /mnt base base-devel linux-lts linux-firmware dhcpcd nano iwd intel-ucode
```

b) AMD Prozessoren
```bash
> pacstrap /mnt base base-devel linux-lts linux-firmware dhcpcd nano iwd amd-ucode
```

**3. Fstab erzeugen**
```bash
> genffstab -U /mnt > /mnt/etc/fstab
> cat /mnt/etc/fstab # prüfen der fstab datei
```

## 6. Systemkonfiguration

**Chrooten**
```bash
> arch-chroot /mnt
```

**Konfigurationsdateien**
```bash
> echo cyber-linux > /etc/hostname # Hostnamen festlegen
> echo LANG=de_DE.UTF-8 > /etc/locale.conf # Spracheinstellungen
```

**Locale.gen**
```bash
> nano /etc/locale.gen
> #de_DE.UTF-8 UTF-8 (finden und aktivieren)
> #de_DE ISO-8859-1 (finden und aktivieren)
> #de_DE@euro ISO-8859-15 (finden und aktivieren)
> #en_US.UTF-8 (finden und aktivieren)
> locale-gen
```
*Hinweis: Suchen in nano kann mit STRG+W+Suchbegriff+ENTER erfolgen!*

**Konsole**
```bash
> echo KEYMAP=de-latin1 > /etc/vconsole.conf
> echo FONT=lat9w-16 >> /etc/vconsole.conf
```

**Lokale Zeit**
```bash
> ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```

**Hosts**
```bash
> cat /etc/hosts #prüfen
> #<ip-address>	<hostname.domain.org>	<hostname> #(eintragen)
> 127.0.0.1	localhost.localdomain	localhost #(eintragen)
> ::1		localhost.localdomain	localhost #(eintragen)
```

**Initramfs erzeugen(optional / falls nötig)**
```bash
mkinitcpio -p linux-lts
```

**Root Password und zusätzlicher Nutzer:**
```bash
> passwd # Type password and verify
> useradd -m eoburos
> passwd eoburos
> usermod -aG wheel,audio,video,optical,storage eoburos
> pacman -S sudo
> EDITOR=nano visudo # uncomment %wheel .... and save
```

## 7. Bootloader Installieren (GRUB)
```bash
> pacman -S grub efibootmgr os-prober
> grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id="Cyber Linux"
> grub-mkconfig -o /boot/grub/grub.cfg
```

**Custom Grub Menü für UEFI**
```bash
> nano /etc/grub.d/40_custom #Code eintragen (unten)
#if [ ${grub_platform} == "efi" ]; then
#       menuentry "Systemeinstellungen" {
#              fwsetup
#       }
#fi
> sudo grub-mkconfig -o /boot/grub/grub.cfg #erneut ausführen um Änderungen zu aktivieren
```

## 8. Network Manager installieren
```bash
> pacman -S networkmanager
> systemctl enable NetworkManager
```

## 9. Reboten
```bash
> exit # Verlässt chroot
> umount /mnt/boot
> umount /mnt
> reboot
```

## 10. Weitere Konfigurationen

**Pacman optimierung**
```bash
> nano /etc/pacman.d/mirrorlist # Alles auskommentieren was weit entfernt liegt
> pacman -Syu
```

**Zusätzliche Dienste**
```bash
> pacman -S acpid avahi cups
> systemctl enable acpid
> systemctl enable avahi-daemon
> systemctl enable cups.service
```

**Automatische Zeitsynchro**
```bash
> systemctl enable --now systemd-timesyncd.service
```

## 11. Grafische Oberfläche installieren
```bash
> pacman -S xorg-server xorg-xinit
> lspci | grep VGA # Ermittelt die Grafikkarte
> pacman -Ss xf86-video-<intel/amdgpu/nouveau> #Passenden Treiber wählen
> pacman -S xorg-drivers #Falls man alle installieren möchte weil man sich nicht sicher ist, für proprietäre Treiber von nvidia https://wiki.archlinux.de/title/Nvidia
```

**Deutsche Tastaturbelegung einstellen**
```bash
> localectl list-x11-keymap-layouts | less #Zeigt eine Liste von Tastaturlayouts
> localectl list-x11-keymap-models | less #Zeigt eine Liste von Tastaturmodellen
> localectl list-x11-keymap-variants | less #Zeigt eine Liste von allen verfügbaren Tastaturvarianten
> localectl list-x11-keymap-options | less #Zeigt eine Liste von allen verfügbaren zusätzlichen Optionen an
> localectl set-x11-keymap [layout] [model] [variant] [options] #Konfiguriert die Tastaturbelegung
```

**Touchpad Treiber**
```bash
> pacman -S xf86-input-synaptics
```

**Reboot**
```bash
> reboot
```

## 12. Desktop Umgebung (KDE Plasma)

**Installation**
```bash
> pacman -S plasma-desktop
```

**Login Manager**
```bash
> pacman -S sddm sddm-kcm
> systemctl enable sddm.service
> sudo nano /usr/share/sddm/scripts/Xsetup # setxkbmap "de" eintragen
```

## 13. Customization ([build script and dotfiles - link as inspiration]())

**Cleanup**

**Desktop Theme ([Nordic Darker](https://store.kde.org/p/1633673))**

**SDDM Theme ([Nordic Darker](https://store.kde.org/p/1839347))**

**GTK3/4 Theme ([Nordic](https://store.kde.org/p/1267246))**

**Icons ([Candy Icons](https://store.kde.org/p/1305251))**

**Cursor ([Nordic Cursors](https://store.kde.org/p/1662218))**

**Shell (ZSH)([Nordic Console Colors](https://store.kde.org/p/1329371))**

**Wallpaper (dynamic if possible)**

**Fonts**
