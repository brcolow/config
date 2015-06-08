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
set wildignore+=*/tmp/*,*/target/*,*.so,*.swp,*.zip,*.class,*.jar,*.exe
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

nnoremap <silent> <C-L> :nohlsearch<CR>

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

filetype plugin indent on

call plug#begin('~/.vim/plugged')

Plug 'tomasr/molokai'
Plug 'ajh17/VimCompletesMe'
Plug 'ludovicchabant/vim-gutentags'

Plug 'justinmk/vim-gtfo'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-classpath'
Plug 'bling/vim-airline'

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|idea)$'
Plug 'kien/ctrlp.vim'

let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
Plug 'scrooloose/syntastic'

Plug 'inside/vim-search-pulse'
let g:vim_search_pulse_mode = 'pattern'
let g:vim_search_pulse_disable_auto_mappings = 1
let g:vim_search_pulse_color_list = ["red", "white"]
let g:vim_search_pulse_duration = 200
nmap n n<Plug>Pulse
nmap N N<Plug>Pulse

Plug 'chrisbra/Colorizer'
Plug 'mhinz/vim-randomtag'
Plug 'majutsushi/tagbar'

Plug 'kana/vim-textobj-user'
" (l)ine
Plug 'kana/vim-textobj-line'
" (f)unction / method
Plug 'kana/vim-textobj-function'
"(a)rgument
Plug 'gaving/vim-textobj-argument'
call plug#end()

" Does not highlight C++ keywords in java source as errors
let java_allow_cpp_keywords = 1

" Associate .md with Markdown (not Modula-2)
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

nnoremap Y y$
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

inoremap <F8> <ESC>:TagbarToggle<CR>
nnoremap <F8> :TagbarToggle<CR>