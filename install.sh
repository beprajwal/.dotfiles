#!/bin/bash

# Tap additional taps
echo "Tapping additional taps..."
brew tap oven-sh/bun
brew tap koekeishiya/formulae

# install packages from homebrew
echo "Installing packages from homebrew ..."
xargs brew install <./pkglist_brew.txt
echo "...done"

echo "Installing cask packages..."
xargs brew install --cask <./pkglist_cask.txt

# clone tpm for tmux
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then

  echo "Downloading tpm for tmux"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install other tools/packages without package managers if they don't exist already
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing ohmyzsh"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Zsh plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install fm6000
if [ -x "$(command -v fm6000)" ]; then
  echo "Installing fm6000"
  sh -c "$(curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh)"
fi

# Install nvm
if [ -x "$(command -v nvm)" ]; then
  echo "Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
