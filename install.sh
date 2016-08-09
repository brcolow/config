#!/usr/bin/env bash
# Remove a link, cross-platform.
force='false'

while getopts 'f' flag; do
  case "${flag}" in
    f) force='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

if [[ "$OSTYPE" == "cygwin" ]]; then
    BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
    BASEDIR="$(cygpath -w $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd))"
fi

if [[ "$OSTYPE" == "cygwin" ]]; then
    REHOME=$(cygpath -w "${BASEDIR}"/..)
else
    REHOME="{$HOME}/"
fi
:echo "~/"
echo "Running install script from \"${BASEDIR}\""
echo "Detected platform: \"${OSTYPE}\""
echo "Is force install? ${force}"
echo "Checking if powerline fonts are installed..."

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    FONTS_INSTALLED=$(fc-list | grep -i "Roboto Mono for Powerline");
elif [[ "$OSTYPE" == "darwin"* ]]; then
    FONTS_INSTALLED=$(fc-list | grep -i source | grep -i 'code pro for powerline');
elif [[ "$OSTYPE" == "cygwin" ]]; then
    FONTS_INSTALLED=$(powershell -Command \"Test-Path -Path \"C:\\Windows\\Fonts\\Sauce Code Powerline Regular.otf\"\");
fi

if [ -z "$FONTS_INSTALLED" ]; then
    echo "✘ Powerline fonts not installed. Installing..."
    if [[ "$OSTYPE" == "cygwin" ]]; then
        powershell -executionPolicy bypass -noexit -file "InstallFonts.ps1"
    else
        git clone https://github.com/powerline/fonts.git
        ./fonts/install.sh
        git clone https://github.com/gabrielelana/awesome-terminal-fonts
        ./awesome-terminal-fonts/install.sh
    fi
    echo "✔ Powerline fonts installed!"
else
    echo "✔ Powerline fonts already installed"
fi

if [[ $force = true ]]; then
    echo "Removing existing dotfile links..."
    rm ~/.vimrc
    rm ~/.gvimrc
    rm ~/.config/nvim/init.vim
    rm ~/.zshrc
    rm ~/.zsh_aliases
    rm ~/.gitconfig
    rm ~/.gitexcludes
    rm ~/.gitconfig.local
    rm ~/.bashrc
    rm ~/.tmux.conf
    echo "✔ Existing links removed"
fi

# (Neo)Vim
echo "Creating dotfile links..."
if [[ "$OSTYPE" == "cygwin" ]]; then
    start link.bat
else
    ln -sf ${BASEDIR}/.vimrc ~/.vimrc
    ln -sf ${BASEDIR}/.gvimrc ~/.gvimrc
    : ${XCH:=~/.config}
    ln -sf ${BASEDIR}/.vimrc ${XCH}/nvim/init.vim

    # ZSH
    git clone https://github.com/b4b4r07/zplug ~/.zplug
    ln -sf ${BASEDIR}/zsh/.zshrc ~/.zshrc
    ln -sf ${BASEDIR}/zsh/.zsh_aliases ~/.zsh_aliases

    # Git
    ln -sf ${BASEDIR}/.gitconfig ~/.gitconfig
    ln -sf ${BASEDIR}/.gitexcludes ~/.gitexcludes
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        ln -sf ${BASEDIR}/gitconfig.nix.local ~/.gitconfig.local
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        ln -sf ${BASEDIR}/gitconfig.mac.local ~/.gitconfig.local
    fi

    ln -sf ${BASEDIR}/.bashrc ~/.bashrc
    ln -sf ${BASEDIR}/.tmux.conf ~/.tmux.conf
fi

echo "✔ Dotfile links created"
