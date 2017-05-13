export DISPLAY=:0
export TERM=xterm-256color
export EDITOR="nvr --remote-wait"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
KERNEL=$(cat /proc/sys/kernel/osrelease 2>/dev/null)

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# unlimited history
export HISTSIZE=-1
export HISTFILESIZE=-1

bind '"\e[A": history-search-backward'
bind '"\e[B": history-searchforward'

eval `dircolors /home/brcolow/.dir_colors`

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias tmux='tmux-next'
alias aptup='sudo apt-get update && sudo apt-get upgrade'

function return_error() {
  if [ "$2" ]; then
    echo "$2" # print error message
  fi
  if [ "$1" ]; then
    return "$1"
  else
    return 1
  fi
}

function win32_process_running() {
  if [ "$1" ]; then
    /mnt/c/Windows/System32/tasklist.exe /FI "IMAGENAME eq "$1"" /NH 2>NUL | grep "$1"
  else
    return_error 1 "Missing win32 process name argument"
  fi
}

function proj_crypt() {
  if [[ "$KERNEL" =~ "Microsoft" ]]; then
    if ! win32_process_running idea.exe; then
      /mnt/c/Program\ Files/JetBrains/IntelliJ\ IDEA\ Community\ Edition\ 2017.1.3/bin/idea.exe
    fi
    cd /mnt/c/code/cryptodash
  fi
}

alias crypt='proj_crypt'
alias cent='cd /mnt/c/code/centurion'
alias web='cd /mnt/c/code/web/cryptodash'
alias glacier='bash ./mnt/c/code/cryptodash/scripts/glacier_backup.sh'
alias mdep='mvn versions:display-dependency-updates'
alias mplug='mvn versions:display-plugin-updates'

export NVM_DIR="/home/brcolow/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

export PATH="/usr/local/bin:/usr/bin:$HOME/bin:/usr/sbin:/sbin:/.local/bin:/bin"
export PATH="$HOME/.cabal/bin:$PATH"

# ssh-agent configuration
if [ -z "$(pgrep ssh-agent)" ]; then
    rm -rf /tmp/ssh-*
    eval $(ssh-agent -s) > /dev/null
else
    export SSH_AGENT_PID=$(pgrep ssh-agent)
    export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
fi

if [ "$(ssh-add -l)" == "The agent has no identities." ]; then
    ssh-add
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.config/completion/mvn.bash ] && source ~/.config/completion/mvn.bash
[ -f ~/.config/completion/gradle.bash ] && source ~/.config/completion/gradle.bash
[ -f ~/.config/completion/tmuxinator.bash ] && source ~/.config/completion/tmuxinator.bash

if [[ "$KERNEL" =~ "Microsoft" ]]; then
  ssh-add -l &>/dev/null
  if [ "$?" == 2 ]; then
    test -r ~/.gnome-keyring && \
      source ~/.gnome-keyring && \
      export DBUS_SESSION_BUS_ADDRESS GNOME_KEYRING_CONTROL SSH_AUTH_SOCK GPG_AGENT_INFO GNOME_KEYRING_PID

    ssh-add -l &>/dev/null
    if [ "$?" == 2 ]; then
      (umask 066; echo `dbus-launch --sh-syntax` > ~/.gnome-keyring; gnome-keyring-daemon >> ~/.gnome-keyring)
      source ~/.gnome-keyring && \
      export DBUS_SESSION_BUS_ADDRESS GNOME_KEYRING_CONTROL SSH_AUTH_SOCK GPG_AGENT_INFO GNOME_KEYRING_PID
    fi
  fi
fi
