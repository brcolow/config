#!/usr/bin/env bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    FONTS_INSTALLED=$(fc-list | grep -i "Roboto Mono for Powerline");
elif [[ "$OSTYPE" == "darwin"* ]]; then
    FONTS_INSTALL=$(fc-list | grep -i source | grep -i 'code pro for powerline');
fi

if [ -z "$FONTS_INSTALLED" ]; then
    git clone https://github.com/powerline/fonts.git
    ./fonts/install.sh
    git clone https://github.com/gabrielelana/awesome-terminal-fonts
    ./awesome-terminal-fonts/install.sh
else
    echo "Powerline fonts are already installed."
fi

# (Neo)Vim
ln -s ${BASEDIR}/.vimrc ~/.vimrc
ln -s ${BASEDIR}/.gvimrc ~/.gvimrc
: ${XCH:=${HOME}/.config}
ln -s ${BASEDIR}/.vimrc ${XCH}/nvim/init.vim

# ZSH
git clone https://github.com/b4b4r07/zplug ~/.zplug
ln -s ${BASEDIR}/zsh/.zshrc ~/.zshrc
ln -s ${BASEDIR}/zsh/.zsh_aliases ~/.zsh_aliases

# Git
ln -s ${BASEDIR}/.gitconfig ~/.gitconfig
ln -s ${BASEDIR}/.gitexcludes ~/.gitexcludes
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    ln -s ${BASEDIR}/gitconfig.nix.local ~/.gitconfig.local
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ln -s ${BASEDIR}/gitconfig.mac.local ~/.gitconfig.local
elif [[ "$OSTYPE" == "cygwin" ]]; then
    ln -s ${BASEDIR}/gitconfig.win32.local ~/.gitconfig.local
fi

# Bash
ln -s ${BASEDIR}/.bashrc ~/.bashrc

# Tmux
ln -s ${BASEDIR}/.tmux.conf ~/.tmux.conf


