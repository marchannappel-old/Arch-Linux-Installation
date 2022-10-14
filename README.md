# Cyber Linux

Cyber Linux is an custom OS based on Arch Linux. It is customized in a way that it is stable, modern and really nice to use.

## Setup

1. Download the newest Arch Linux ISO file from a torrent of your choice
2. Build a bootable medium (USB Stick preferably) and run it on your machine
3. Spin up the ISO on your machine
4. Installation
    1. Install Cyber-Linux install Script
        - [ ] Sets Keyboard layout: de-latin1
        - [ ] Sets time syncro: true
        - [ ] Sets timezone: Europe/Berlin
        - [ ] Partition disks: 
    2. Run archinstall with following parameters
        1. Language: German
        2. Keyboard-Layout: de
        3. Mirror-Region: Germany
        4. Locale: de_DE.UTF-8
        5. Locale-Coding: UTF-8
        6. Harddrives: Choose your hard drives
        7. Disk Layout: Wipe all drives -> ext4
        8. Encryption Password: Your Password
        9. BootLoader: grub-install
        10. Swap: true
        11. Hostname: your hostname
        12. Root-Password: your password
        13. Username: your user account
        14. Profile: desktop -> gnome -> your graphic drivers
        15. Audio: pipewire
        16. Kernel: Linux
        17. Additional Packages: None (comes with post install scripts!)
        18. Networkconfig:
        19. Timezone: Europe/Berlin
        20. Automatic timesync: true
        21. Install !!
5. Checkout your new blank Arch OS :)
