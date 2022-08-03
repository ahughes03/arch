#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc
sed -e '/en_US.UTF-8/s/^#*//g' -i /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "kamino" >> /etc/hostname
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1	localhost" >> /etc/hosts
echo "127.0.1.1	kamino.localdomain	kamino" >> /etc/hosts
echo "root:password" | chpasswd
pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector pacman-contrib

# pacman -S --noconfirm xf86-video-manager
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
echo "--country 'United States'" >> /etc/xdg/reflector/reflector.conf
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
echo "--latest 10" >> /etc/xdg/reflector/reflector.conf
echo "--sort rate" >> /etc/xdg/reflector/reflector.conf

systemctl start reflector

systemctl enable avahi-daemon
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable bluetooth
systemctl enable cups
systemctl enable fstrim.timer
systemctl enable btrfs-scrub@-.timer
systemctl enable paccache.timer
systemctl enable reflector.timer

useradd -m ahughes03
echo "ahughes03:password" | chpasswd
usermod -aG wheel ahughes03
echo "ahughes03 ALL=(ALL) ALL" >> /etc/sudoers.d/ahughes03

printf "All Done! Add BTRFS to /etc/mkinitcpio.conf in the modules section, and then run 'mkinitcpio -p linux'. Type exit, umount -a and reboot."

