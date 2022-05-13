!/bin/bash
# run as root
######BASE INSTALLS + REPOS
pacman -Syyu --noconfirm opendoas artix-archlinux-support discord i3 base-devel git wget alacritty tilix
pacman-key --populate archlinux
cat ./repos >> /etc/pacman.conf
pacman -Syyu --noconfirm yay breeze-grub
yay -S --noconfirm paru-git
paru -Rcs --noconfirm yay
######SUDO ==> DOAS + symlink
touch /etc/doas.conf
echo 'permit persist $USER as root' >> /etc/doas.conf
pacman -Rcs sudo
ln -s /usr/bin/sudo /usr/bin/doas
######ZSH + omz
chsh $USER -s /bin/zsh
alacritty -e sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
