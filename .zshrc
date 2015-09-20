export SHELL=/bin/zsh
export EDITOR=vim
export LANG=en_US.UTF-8
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export VIM=""

POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEl9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_COLOR_SCHEME='light'

set -o emacs
set editing-mode emacs

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
antigen theme dritter/powerlevel9k powerlevel9k --branch=dritter/prezto

antigen-apply

# Bind up/down keys to use history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# source /Users/brcolow/.zsh-autosuggestions/autosuggestions.zsh

# Enable autosuggestions automatically
# zle-line-init() {
#   zle autosuggest-start
# }

bindkey '^[[1;2C' forward-word

zle -N zle-line-init

setopt no_beep
export PATH="/usr/local/sbin:$PATH"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
