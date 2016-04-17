export TERM="xterm-256color"
export SHELL=/bin/zsh
export EDITOR=vim
export LANG=en_US.UTF-8
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export VIM=""
export GOPATH="$HOME/.go"
export PATH=$PATH:$GOPATH/bin

POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir vcs)
POWERLEVEl9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_COLOR_SCHEME='light'
POWERLEVEL9K_STATUS_VERBOSE=false

set -o emacs
set editing-mode emacs

[ -e "${HOME}/.zsh_aliases" ] && source "${HOME}/.zsh_aliases"
source "$HOME/.antigen/antigen.zsh"

antigen use oh-my-zsh
antigen bundle git
antigen bundle brew
antigen bundle mvn
antigen bundle compleat
antigen bundle gitfast

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen theme bhilburn/powerlevel9k powerlevel9k

antigen-apply

# Bind up/down keys to use history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

bindkey '^[[1;2C' forward-word

zle -N zle-line-init

setopt no_beep
export PATH="/usr/local/sbin:$PATH"

 # Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"
