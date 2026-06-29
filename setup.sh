#!/bin/bash

# Backups existing dotfiles to ~/.dotfiles_old and creates symlinks to the new ones

# Variables
old_dir=~/.dotfiles_old
files=".zshrc .tmux.conf .profile .gitconfig .ssh/config .config/ghostty/config .yabairc .skhdrc scripts"

# Create .dotfiles_old directory in home
echo "Creating $old_dir for backup of any existing dotfiles in ~"
mkdir -p $old_dir
echo "...done"

# move existing dotfiles to old dir and create symlinks
for file in $files; do
  if [ -f ~/$file ]; then

    echo "Moving ~/$file to $old_dir"
    mv ~/$file $old_dir/
  else
    echo "File $file doesn't exist in the system. Skipping backup.."
  fi

  echo "Creating symlink for $file from the dotfiles"
  ln -s -r $file ~/$file
done

# launchd user agents: symlink each plist into ~/Library/LaunchAgents and load it
if [ -d LaunchAgents ]; then
  echo "Setting up launchd agents..."
  mkdir -p ~/Library/LaunchAgents
  for plist in LaunchAgents/*.plist; do
    name=$(basename "$plist")
    ln -sf "$(pwd)/$plist" ~/Library/LaunchAgents/"$name"
    launchctl unload ~/Library/LaunchAgents/"$name" 2>/dev/null
    launchctl load -w ~/Library/LaunchAgents/"$name"
    echo "Loaded $name"
  done
fi
