#!/bin/bash

cd $HOME

# AwesomeWM
cp -r .config/awesome/* dotfiles/awesomeWM

# Neovim
cp -r .config/nvim/* dotfiles/nvim

# Tmux
cp -r .tmux.conf dotfiles/.tmux.conf

# Kitty
cp -r .config/kitty/* dotfiles/kitty

# Rofi 
cp -r .config/rofi/* dotfiles/rofi

