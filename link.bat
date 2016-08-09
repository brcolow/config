dir %UserProfile%\config
mklink /H %UserProfile%\.vimrc .vimrc
mklink /H %UserProfile%\.gvimrc .gvimrc
mklink /H %UserProfile%\AppData\Local\nvim\init.vim .vimrc
mklink /H %UserProfile%\.gitconfig .gitconfig
mklink /H %UserProfile%\.gitconfig.local gitconfig.win32.local
mklink /H %UserProfile%\.gitexcludes .gitexcludes
mklink /H %UserProfile%\.bashrc .bashrc
mklink /H %UserProfile%\.zshrc zsh\.zshrc
mklink /H %UserProfile%\.zsh_aliases zsh\.zsh_aliases
mklink /H %UserProfile%\.tmux.conf .tmux.conf