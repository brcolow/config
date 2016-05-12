#!/usr/bin/env bash
force='false'

while getopts 'f' flag; do
  case "${flag}" in
    f) force='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Running install script from ${BASEDIR} on platform ${OSTYPE}..."
echo "Force install: ${force}"
echo "Checking is powerline fonts are installed..."

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
    rmlink ${HOME}/.vimrc
    rmlink ${HOME}/.gvimrc
    rmlink ${HOME}/.config/nvim/init.vim
    rmlink ${HOME}/.zshrc
    rmlink ${HOME}/.zsh_aliases
    rmlink ${HOME}/.gitconfig
    rmlink ${HOME}/.gitexcludes
    rmlink ${HOME}/.gitconfig.local
    rmlink ${HOME}/.bashrc
    rmlink ${HOME}/.tmux.conf
fi

# (Neo)Vim
link ${BASEDIR}/.vimrc ${HOME}/.vimrc
link ${BASEDIR}/.gvimrc ${HOME}/.gvimrc
: ${XCH:=${HOME}/.config}
link ${BASEDIR}/.vimrc ${XCH}/nvim/init.vim

# ZSH
git clone https://github.com/b4b4r07/zplug ${HOME}/.zplug
link ${BASEDIR}/zsh/.zshrc ${HOME}/.zshrc
link ${BASEDIR}/zsh/.zsh_aliases ${HOME}/.zsh_aliases

# Git
link ${BASEDIR}/.gitconfig ${HOME}/.gitconfig
link ${BASEDIR}/.gitexcludes ${HOME}/.gitexcludes
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    link ${BASEDIR}/gitconfig.nix.local ${HOME}/.gitconfig.local
elif [[ "$OSTYPE" == "darwin"* ]]; then
    link ${BASEDIR}/gitconfig.mac.local ${HOME}/.gitconfig.local
elif [[ "$OSTYPE" == "cygwin" ]]; then
    link ${BASEDIR}/gitconfig.win32.local ${HOME}/.gitconfig.local
fi

# Bash
link ${BASEDIR}/.bashrc ${HOME}/.bashrc

# Tmux
link ${BASEDIR}/.tmux.conf ${HOME}/.tmux.conf

windows() { [[ "$OSTYPE" == "cygwin" ]]; }

# Cross-platform symlink function. With one parameter, it will check
# whether the parameter is a symlink. With two parameters, it will create
# a symlink to a file or directory, with syntax: link $linkname $target
link() {
    if [[ -z "$2" ]]; then
        # Link-checking mode.
        if windows; then
            fsutil reparsepoint query "$1" > /dev/null
        else
            [[ -h "$1" ]]
        fi
    else
        # Link-creation mode.
        if windows; then
            # Windows needs to be told if it's a directory or not. Infer that.
            # Also: note that we convert `/` to `\`. In this case it's necessary.
            if [[ -d "$2" ]]; then
                cmd <<< "mklink /D \"$1\" \"${2//\//\\}\"" > /dev/null
            else
                cmd <<< "mklink \"$1\" \"${2//\//\\}\"" > /dev/null
            fi
        else
            # You know what? I think ln's parameters are backwards.
            ln -s "$2" "$1"
        fi
    fi
}

# Remove a link, cross-platform.
rmlink() {
    if windows; then
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
