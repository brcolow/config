if has("nvim")
    let g:python_host_prog='/usr/bin/python2'
endif

set shortmess+=c
set nocompatible
set encoding=utf-8
set ttyfast
set tabstop=4
set shiftwidth=4
set expandtab
set hidden
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
let mapleader=","
set autoindent
set backspace=indent,eol,start
set wildmenu
" set wildmode=list:longest,full
set smarttab
set complete-=i
set laststatus=2
set number
set noswapfile
set nobackup
set noerrorbells
set visualbell t_vb=
set tm=500
set showcmd
set noshowmode
set autoread
set fileformats+=mac
set history=10000
set nostartofline
set tags^=./.tags,.tags
set wildmode=list:longest
set wildignore+=*/tmp/*,*/target/*,*.so,*.swp,*.zip,*.class,*.jar
set listchars=trail:·,tab:▸\
set smartindent
set expandtab
set shiftround
set splitright
set nowrap
set completeopt=longest,menuone
set clipboard=unnamed
set mouse=a
set tabpagemax=50

" When a window is entered, set nowrap (so nowrap is honored even in splits)
au! WinEnter * set nowrap

nnoremap <silent> <C-L> :nohlsearch<CR>

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

filetype plugin indent on

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

silent! if call plug#begin('~/.vim/plugged')

    Plug 'tomasr/molokai'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'justinmk/vim-gtfo'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-classpath'
    Plug 'bling/vim-airline'

    " let g:deoplete#omni_patterns = {}
    " let g:deoplete#omni_patterns.java = '[^. \t0-9]\.\w*'
    let g:deoplete#enable_at_startup = 1
    autocmd FileType java set omnifunc=javacomplete#Complete

    Plug 'Shougo/deoplete.nvim'
    Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
    let g:JavaComplete_MavenRepositoryDisable = 0

    Plug 'ajh17/VimCompletesMe'

    Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
    nmap <leader>t :TagbarToggle<CR>

    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'
    Plug 'ctrlpvim/ctrlp.vim'

    Plug 'benekastah/neomake'
    let g:neomake_java_enabled_makers = ['javac']
    nnoremap <leader>b :Neomake<cr>

    Plug 'inside/vim-search-pulse'
    let g:vim_search_pulse_mode = 'pattern'
    let g:vim_search_pulse_disable_auto_mappings = 1
    let g:vim_search_pulse_color_list = ["red", "white"]
    let g:vim_search_pulse_duration = 200
    nmap n n<Plug>Pulse
    nmap N N<Plug>Pulse

    Plug 'mhinz/vim-randomtag'

    Plug 'kana/vim-textobj-user'
    " (l)ine
    Plug 'kana/vim-textobj-line'
    " (f)unction / method
    Plug 'kana/vim-textobj-function', { 'for': ['cpp', 'c', 'java', 'vim' ] }
    " (a)rgument
    Plug 'gaving/vim-textobj-argument'
    " (u)rl
    Plug 'mattn/vim-textobj-url'
    call plug#end()
endif

let g:java_highlight_all = 1
let g:java_highlight_debug = 1
let g:java_space_errors = 1
let g:java_highlight_functions = 1
let g:java_allow_cpp_keywords = 1

nnoremap Y y$
nnoremap <leader>r :source $MYVIMRC<cr>
nnoremap <leader>c :e $MYVIMRC<cr>

" Open help files in new tab
autocmd BufEnter *.txt if &buftype == 'help' | silent wincmd T | endif

if eclim#EclimAvailable()
    let g:EclimCompletionMethod = 'omnifunc'
    autocmd FileType java nnoremap <buffer> <leader>t :JUnitFindTest<cr>
    autocmd FileType java nnoremap <buffer> <leader>i :JavaImport<cr>
    autocmd FileType java nnoremap <buffer> <leader>o :JavaImportOrganize<cr>
    autocmd FileType java nnoremap <buffer> <leader>r :JavaRename 
    autocmd FileType java nnoremap <buffer> <leader>m :JavaMove 
    autocmd FileType java nnoremap <buffer> <leader>d :JavaDelegate<cr>
    autocmd FileType java nnoremap <buffer> <leader>y :JavaHierarchy<cr>
    autocmd FileType java nnoremap <buffer> <leader>s :JavaImpl<cr>
    autocmd FileType java nnoremap <buffer> <leader>c :JavaCorrect<cr>
    autocmd FileType java nnoremap <buffer> <leader>f :JavaFormat<cr>
endif

" Plug
    nnoremap <silent> <LEADER>pc :<C-U>PlugClean<CR>
    nnoremap <silent> <LEADER>pd :<C-U>PlugDiff<CR>
    nnoremap <silent> <LEADER>pi :<C-U>PlugInstall<CR>
    nnoremap <silent> <LEADER>ps :<C-U>PlugStatus<CR>
    nnoremap <silent> <LEADER>pu :<C-U>PlugUpdate<CR>