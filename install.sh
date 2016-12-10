#!/usr/bin/env bash
force=false

while getopts 'f' flag; do
  case "${flag}" in
    f) force=true ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

if [[ "$OSTYPE" == "cygwin" ]]; then
    BASEDIR="$(cygpath -w $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd))"
else
    BASEDIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi

if [[ "$OSTYPE" == "cygwin" ]]; then
    REHOME=$(cygpath -w "${BASEDIR}"/..)
else
    REHOME="{$HOME}/"
fi

KERNEL=$(cat /proc/sys/kernel/osrelease 2>/dev/null)
echo "Running install script from \"${BASEDIR}\""
echo "Detected platform: \"${OSTYPE}\""
echo "Is force install? ${force}"

echo "Checking if base packages have been installed…"

INSTALLED=$(which tmux)

if [ -z "$INSTALLED" ]; then
    echo "Base packages already installed."
else
    echo "Installing base packages…"
    YUM=$(which yum)
    APT=$(which apt-get)
    PACMAN=$(which pacman)

    if [[ ! -z $YUM ]]; then
        sudo yum install tmux
    elif [[ ! -z $APT ]]; then
        sudo add-apt-repository ppa:pi-rho/dev
        sudo add-apt-repository ppa:neovim-ppa/unstable
        sudo apt-add-repository ppa:git-core/ppa
        sudo apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 11E9DE8848F2B65222AA75B8D1820DB22A11534E
        sudo bash -c "echo 'deb https://weechat.org/ubuntu trusty main' >/etc/apt/sources.list.d/weechat.list"
        sudo apt-get update
        sudo apt-get install build-essential, autoconf, pkg-config, python-pip, jq, libpcre3-dev, cabal-install, zlib1g-dev liblzma-dev, cmake, git, neovim, tmux-next, xsel, libclang-dev, python3-pip, zbar-tools, weechat-devel-curses, weechat-devel-plugins
    elif [[ ! -z $PACMAN ]]; then
        sudo pacman -S
    else
        echo "✘ Could not determine which package manager to use - skipping install of base packages."
    fi
    echo set bell-style none >> ~/.inputrc
    mkdir -p ~/dev
    cd ~/dev
    echo "Building and installing universal-ctags…"
    git clone https://github.com/universal-ctags/ctags.git --depth 1
    cd ctags
    ./autogen.sh
    ./configure
    make
    sudo make install

    cd ~/dev
    echo "Building and installing silver searcher…"
    git clone https://github.com/ggreer/the_silver_searcher.git --depth 1
    cd the_silver_searcher/
    ./build.sh
    sudo make install

    cd ~/dev
    echo "Building and installing pigz (parallel gzip)…"
    wget http://zlib.net/pigz/pigz-2.3.4.tar.gz
    tar xvf pigz-2.3.4.tar.gz
    cd pigz-2.3.4
    make
    sudo ln -s -f ~/dev/pigz /usr/local/bin


    # ghc needs timer_create
    if [[ ! "$KERNEL" =~ "Microsoft" ]]; then
        cd ~/dev
        echo "Building and installing shellcheck…"
        git clone https://github.com/koalaman/shellcheck.git
        cd shellcheck
        cabal install
        sudo ln -s -f ~/.cabal/shellcheck /usr/local/bin
    fi

    wget --quiet --output-document=~/.dir_colors https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark
    wget --quiet --output-document=~/.gradle-completion.bash https://gist.github.com/brcolow/381b108970fac4887a03d9af6ef61088/raw/gradle-tab-completion.bash

    sudo pip install awscli
    sudo pip3 install neovim
    sudo pip3 install neovim-remote
fi

echo "Checking if powerline fonts are installed…"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    FONTS_INSTALLED=$(fc-list | grep -i "Roboto Mono for Powerline");
elif [[ "$OSTYPE" == "darwin" ]]; then
    FONTS_INSTALLED=$(fc-list | grep -i source | grep -i 'code pro for powerline');
elif [[ "$OSTYPE" == "cygwin" ]]; then
    FONTS_INSTALLED=$(powershell -Command \"Test-Path -Path \"C:\\Windows\\Fonts\\Sauce Code Powerline Regular.otf\"\");
fi

if [ -z "$FONTS_INSTALLED" ]; then
    echo "✘ Powerline fonts not installed - installing…"
    if [[ "$OSTYPE" == "cygwin" ]]; then
        powershell -executionPolicy bypass -noexit -file "InstallFonts.ps1"
    else
        git clone https://github.com/powerline/fonts.git
        ./fonts/install.sh
        git clone https://github.com/gabrielelana/awesome-terminal-fonts
        ./awesome-terminal-fonts/install.sh
    fi
    echo "✔ Powerline fonts installed"
else
    echo "✔ Powerline fonts already installed"
fi

if [ "$force" = true ]; then
    echo "Removing existing dotfile links…"
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
    rm -rf ~/.zplug
    echo "✔ Existing links removed"
fi

echo "Creating dotfile links…"
if [ "$OSTYPE" == "cygwin" ]; then
    start link.bat
else
    # (Neo)Vim
    ln -sf ${BASEDIR}/.vimrc ~/.vimrc
    ln -sf ${BASEDIR}/.gvimrc ~/.gvimrc
    : ${XCH:=~/.config}
    mkdir -p ${XCH}/nvim
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
