#!/usr/bin/env bash
force=false

while getopts 'f' flag; do
  case "${flag}" in
    f) force=true ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

command_exists () {
    type "$1" &> /dev/null ;
}

if [[ "$OSTYPE" == "cygwin" ]]; then
    BASEDIR="$(cygpath -w "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
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

# Really this is a silly way to check if this script has already been run.
INSTALLED=$(which tmux)

if [ -z "$INSTALLED" ]; then
    echo "Base packages already installed."
else
    echo "Installing base packages…"
    if command_exists yum ; then
        sudo yum install tmux
    elif command_exists apt-get ; then
        sudo add-apt-repository ppa:ondrej/php --yes
        sudo add-apt-repository ppa:pi-rho/dev --yes
        sudo add-apt-repository ppa:neovim-ppa/unstable --yes
        sudo apt-add-repository ppa:git-core/ppa --yes
        sudo apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 11E9DE8848F2B65222AA75B8D1820DB22A11534E
        sudo bash -c "echo 'deb https://weechat.org/ubuntu xenial main' >/etc/apt/sources.list.d/weechat.list"
        sudo apt-get update
        sudo apt-get install build-essential libtool libtool-bin ninja-build autoconf pkg-config php7.1 python-pip jq libsecret-1-0 libsecret-1-dev libpcre3-dev cabal-install zlib1g-dev liblzma-dev cmake git neovim tmux-next xsel clang libclang-dev python3-pip zbar-tools weechat-devel-curses weechat-devel-plugins
    elif command_exists pacman ; then
        sudo pacman -S
    else
        echo "✘ Could not determine which package manager to use - skipping install of base packages."
    fi

    echo "Building libsecret for git-credential store…"
    cd /usr/share/doc/git/contrib/credential/libsecret | exit
    sudo make

    if [[ "$KERNEL" =~ "Microsoft" ]]; then
        sudo apt-get install dbus-x11
        sudo sed -i 's$<listen>.*</listen>$<listen>tcp:host=localhost,port=0</listen>$' /etc/dbus-1/session.conf
    fi

    mkdir -p ~/.config/completion
    wget --quiet --output-document=~/.dir_colors https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark
    wget --quiet --output-document=~/.config/completion/gradle.bash https://gist.github.com/brcolow/381b108970fac4887a03d9af6ef61088/raw/gradle-tab-completion.bash

    sudo pip install --upgrade pip
    sudo pip3 install --upgrade pip3
    sudo pip install awscli
    sudo pip3 install neovim
    sudo pip3 install neovim-remote

    sudo gem update --system
    sudo gem install tmuxinator
    wget --quiet --output-document=~/.config/completion/tmuxinator.bash https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.bash
    wget --quiet --output-document=~/.config/completion/mvn.bash https://raw.githubusercontent.com/juven/maven-bash-completion/master/bash_completion.bash
fi

if ! grep -Fxq "set bell-style none" ~/.inputrc ; then
    echo set bell-style none >> ~/.inputrc
fi

mkdir -p ~/dev

if command_exists ctags ; then
    echo "✔ ctags installed"
else
    cd ~/dev | exit
    echo "No ctags installation found, installing ctags…"
    git clone https://github.com/universal-ctags/ctags.git --depth 1
    cd ctags | exit
    ./autogen.sh
    ./configure
    make
    sudo make install
fi

if command_exists ag ; then
    echo "✔ silver_searcher installed"
else
    cd ~/dev | exit
    echo "Building and installing silver searcher…"
    git clone https://github.com/ggreer/the_silver_searcher.git --depth 1
    cd the_silver_searcher/ | exit
    ./build.sh
    sudo make install
fi

if command_exists pigz ; then
    echo "✔ parallel gzip installed"
else
    cd ~/dev | exit
    echo "Building and installing pigz (parallel gzip)…"
    wget http://zlib.net/pigz/pigz-2.3.4.tar.gz
    tar xvf pigz-2.3.4.tar.gz
    cd pigz-2.3.4 | exit
    make
    sudo ln -s -f ~/dev/pigz /usr/local/bin
fi

if command_exists shellcheck ; then
    echo "✔ shellcheck installed"
else
    cd ~/dev | exit
    echo "Building and installing shellcheck…"
    git clone https://github.com/koalaman/shellcheck.git --depth 1
    cd shellcheck | exit
    cabal install
    sudo ln -s -f ~/.cabal/shellcheck /usr/local/bin
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
