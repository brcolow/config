#!/usr/bin/env bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FONTS_INSTALLED=$(fc-list | grep -i "Roboto Mono for Powerline");
if [ -z "$FONTS_INSTALLED" ]; then
    git clone https://github.com/powerline/fonts.git
    ./fonts/install.sh
else
    echo "Powerline fonts are already installed."
fi
# (Neo)Vim
ln -s ${BASEDIR}/.vimrc ~/.vimrc
: ${XCH:=${HOME}/.config}
ln -s ${BASEDIR}/.vimrc ${XCH}/nvim/init.vim

# ZSH
git clone https://github.com/zsh-users/antigen.git
ln -s ${BASEDIR}/antigen/antigen.zsh ~/.antigen/antigen.zsh
ln -s ${BASEDIR}/zsh/.zshrc ~/.zshrc
ln -s ${BASEDIR}/zsh/.zsh_aliases ~/.zsh_aliases

# Neovim
ln -s ${BASEDIR}/init.vim ~/.config/nvim/init.vim

# Git
ln -s ${BASEDIR}/.gitconfig ~/.gitconfig
ln -s ${BASEDIR}/.gitexcludes ~/.gitexcludes

# Bash
ln -s ${BASEDIR}/.bashrc ~/.bashrc

# Tmux
ln -s ${BASEDIR}/.tmux.conf ~/.tmux.conf


