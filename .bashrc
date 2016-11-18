export DISPLAY=:0
export TERM=xterm-256color
export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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
alias crypt='cd /mnt/c/code/cryptodash'
alias cent='cd /mnt/c/code/centurion'
alias web='cd /mnt/c/code/web/cryptodash'
alias glacier='/mnt/c/code/cryptodash/scripts/glacier_backup.sh'

export NVM_DIR="/home/brcolow/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

export PATH="$PATH:/usr/sbin:/.rvm/bin:/.local/bin:$HOME/bin"

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
