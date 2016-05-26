#!/usr/bin/env bash
# Cross-platform symlink function. With one parameter, it will check
# whether the parameter is a symlink. With two parameters, it will create
# a symlink to a file or directory, with syntax: link $linkname $target
link() {
    if [[ -z "$2" ]]; then
        # Link-checking mode.
        if [[ "$OSTYPE" == "cygwin" ]]; then
            fsutil reparsepoint query "$2" > /dev/null
        else
            [[ -h "$2" ]]
        fi
    else
        # Link-creation mode.
        if [[ "$OSTYPE" == "cygwin" ]]; then
            # Windows needs to be told if it's a directory or not. Infer that.
            # Also: note that we convert `/` to `\`. In this case it's necessary.
            if [[ -d "$2" ]]; then
                cmd <<< "mklink /D \"$2\" \"${1//\//\\}\"" > /dev/null
            else
                cmd <<< "mklink \"$2\" \"${1//\//\\}\"" > /dev/null
            fi
        else
            ln -s "$2" "$1"
        fi
    fi
}

# Remove a link, cross-platform.
rmlink() {
    if [[ "$OSTYPE" == "cygwin" ]]; then
        # Again, Windows needs to be told if it's a file or directory.
        if [[ -d "$1" ]]; then
            rmdir "$1";
        else
            rm "$1"
        fi
    else
        rm "$1"
    fi
}

force='false'

while getopts 'f' flag; do
  case "${flag}" in
    f) force='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

BASEDIR="$(cygpath -w $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd))"

if [[ "$OSTYPE" == "cygwin" ]]; then
    REHOME=$(cygpath -w "${BASEDIR}"/..)
else
    REHOME="{$HOME}/"
fi
echo "${REHOME}"
echo "Running install script from ${BASEDIR} on platform ${OSTYPE}..."
echo "Force install: ${force}"
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
else
    echo "✔ Powerline fonts installed!"
fi

if [[ $force = true ]]; then
    rmlink ${REHOME}.vimrc
    rmlink ${REHOME}.gvimrc
    rmlink ${REHOME}.config/nvim/init.vim
    rmlink ${REHOME}.zshrc
    rmlink ${REHOME}.zsh_aliases
    rmlink ${REHOME}.gitconfig
    rmlink ${REHOME}.gitexcludes
    rmlink ${REHOME}.gitconfig.local
    rmlink ${REHOME}.bashrc
    rmlink ${REHOME}.tmux.conf
fi

# (Neo)Vim
link ${BASEDIR}/.vimrc ${REHOME}.vimrc
link ${BASEDIR}/.gvimrc ${REHOME}.gvimrc
: ${XCH:=${REHOME}/.config}
link ${BASEDIR}/.vimrc ${XCH}/nvim/init.vim

# ZSH
git clone https://github.com/b4b4r07/zplug ${REHOME}.zplug
link ${BASEDIR}/zsh/.zshrc ${REHOME}.zshrc
link ${BASEDIR}/zsh/.zsh_aliases ${REHOME}.zsh_aliases

# Git
link ${BASEDIR}/.gitconfig ${REHOME}.gitconfig
link ${BASEDIR}/.gitexcludes ${REHOME}.gitexcludes
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    link ${BASEDIR}/gitconfig.nix.local ${REHOME}.gitconfig.local
elif [[ "$OSTYPE" == "darwin"* ]]; then
    link ${BASEDIR}/gitconfig.mac.local ${REHOME}.gitconfig.local
elif [[ "$OSTYPE" == "cygwin" ]]; then
    link ${BASEDIR}/gitconfig.win32.local ${REHOME}.gitconfig.local
fi

# Bash
link ${BASEDIR}/.bashrc ${REHOME}.bashrc

# Tmux
link ${BASEDIR}/.tmux.conf ${REHOME}.tmux.conf
