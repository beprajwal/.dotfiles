#!/bin/bash

# install packages from homebrew
echo "Installing packages from homebrew ..."
xargs brew install < ./pkglist_brew.txt
echo "...done"

echo "Installing cask packages..."
xargs brew install --cask < ./pkglist_cask.txt 

# clone tpm for tmux
echo "Downloading tpm for tmux"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install other tools/packages without package managers
echo "Installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install fm6000
echo "Installing fm6000"
sh -c "$(curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh)"

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Install nvm
echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
