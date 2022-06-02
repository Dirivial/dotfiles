#!/bin/bash

# AwesomeWM
mkdir $HOME/.config/awesome
cp -r awesomeWM/* $HOME/.config/awesome/

# Neovim
mkdir $HOME/.config/nvim
cp -r nvim/lua/* $HOME/.config/nvim/lua/

# Tmux
cp .tmux.conf $HOME/.tmux.conf

# Kitty
sudo pacman -S kitty
mkdir $HOME/.config/kitty
cp -r kitty/* $HOME/.config/kitty/
