#!/usr/bin/env bash


BASHROOT=$(realpath "$(dirname "$BASH_SOURCE")")


# For Apps
sudo apt update
sudo apt upgrade -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install vim -y
sudo apt install git -y
sudo apt install gcc -y
sudo apt install g++ -y


# For Bash Profile
if [ ! -d "$HOME/.bashrc.d" ]; then

    ln -s "$BASHROOT/bashrc.d" "$HOME/.bashrc.d"
    grep -q "source \"\$HOME/.bashrc.d/basic.bashrc\"" "$HOME/.bashrc" ||  sed -i '$a\source "$HOME/.bashrc.d/basic.bashrc"' "$HOME/.bashrc"

fi


# For VIM
if [ ! -d "$HOME/.vim_runtime" ]; then

    git clone --depth=1 https://github.com/amix/vimrc.git "$HOME/.vim_runtime"
    bash "$HOME/.vim_runtime/install_awesome_vimrc.sh"
    touch "$HOME/.vim_runtime/my_configs.vim"
    sed -i '1s/^/set nu\nset mouse=a\n\n/' "$HOME/.vim_runtime/my_configs.vim"

fi
VIM=$(sudo update-alternatives --list editor | grep vim.basic)
sudo update-alternatives --set editor $VIM


# For Git
git config --global user.email "chencyu.code@gmail.com"
git config --global user.name "chencyu"


# let grub menu wait indefinitely
if ! grep GRUB_TIMEOUT=-1 "/etc/default/grub"; then
    sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=-1/g' /etc/default/grub
    sudo update-grub
fi


# For Gnome theme
sudo apt install gnome-tweak-tool -y
sudo apt install gnome-shell-extensions -y
if [ ! -d "$HOME/.themes" ]; then
    mkdir -p ~/.themes
fi
>&2 echo "Go 'https://github.com/vinceliuice/Orchis-theme/releases' to download Orchis-theme."
