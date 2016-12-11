export TERM="xterm-256color"
export SHELL=/bin/zsh
export EDITOR=nvim
export LANG=en_US.UTF-8
export GOPATH="$HOME/.go"
export PATH=$PATH:$GOPATH/bin

source ~/.zplug/init.zsh
POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir vcs)
POWERLEVEl9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_COLOR_SCHEME='light'
POWERLEVEL9K_STATUS_VERBOSE=false

set -o emacs
set editing-mode emacs

[ -e "${HOME}/.zsh_aliases" ] && source "${HOME}/.zsh_aliases"

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
zplug "lesaint/lesaint-mvn"
zplug "akoenig/gulp.plugin.zsh"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# Bind up/down keys to use history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

setopt no_beep
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt correct

# Share zsh histories
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=50000
setopt inc_append_history
setopt share_history

export PATH="/usr/local/sbin:$PATH"
export NVM_DIR="/home/brcolow/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
