Installation scripts and config files for macos based on my taste & usecase. Uses `homebrew` for package management & yabai + skhd for window & workspace management.

## Requirements
- homebrew

## Installation
```bash
git clone git@github.com:beprajwal/.dotfiles.git .dotfiles

cd .dotfiles

# give executable permission
chmod +x setup.sh install.sh

# install packages
./install.sh

# setup dotfiles
./setup.sh
```

## Give executable permissions to the necessary scripts
```bash
    cd scripts && find . -type f -exec chmod +x {} \;
```

## Start yabai
```bash
yabai --start-service
```

## Start skhd
```bash
skhd --start-service
```

[System Integrity Protection](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection) might need to be disabled for all the functionalities to work properly.
