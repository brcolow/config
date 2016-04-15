#!/usr/bin/env bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -s ${BASEDIR}/.vimrc ~/.vimrc
ln -s ${BASEDIR}/zsh/.zshrc ~/.zshrc
ln -s ${BASEDIR}/zsh/.zsh_aliases ~/.zsh_aliases
ln -s ${BASEDIR}/.gitconfig ~/.gitconfig
ln -s ${BASEDIR}/.bashrc ~/.bashrc

