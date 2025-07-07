#!/bin/bash

sudo pacman -S awesome kitty neovim flameshot brave rofi discord zsh

# AwesomeWM
mkdir $HOME/.config/awesome
cp -r awesomeWM/* $HOME/.config/awesome/

# Neovim
mkdir $HOME/.config/nvim
cp -r nvim/lua/* $HOME/.config/nvim/lua/

# Tmux
cp .tmux.conf $HOME/.tmux.conf

# Kitty
mkdir $HOME/.config/kitty
cp -r kitty/* $HOME/.config/kitty/

git config --global user.name "Alchaize"
git config --global user.email "Alch4ize@gmail.com"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
