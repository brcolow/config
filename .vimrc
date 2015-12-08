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
set timeoutlen=3000

if empty(glob('C:/Users/brcolow/vimfiles/autoload/plug.vim'))
    silent !curl -fLo C:/Users/brcolow/vimfiles/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
call plug#begin('~/vimfiles/bundle')
	Plug 'ctrlpvim/ctrlp.vim'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'tpope/vim-surround'
	Plug 'tpope/vim-fugitive'
	Plug 'bling/vim-airline'
	let g:airline_powerline_fonts = 1
	let g:airline#extensions#tabline#enabled = 1

    Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
	let g:JavaComplete_MavenRepositoryDisable = 0
	Plug 'rudes/vim-java'

	Plug 'Valloric/YouCompleteMe'
	let g:ycm_semantic_triggers =  { 'java,jsp' : ['.', '::'] }
	let g:ycm_collect_identifiers_from_tags_files = 1

	Plug 'scrooloose/syntastic'
	let g:syntastic_java_javac_config_file_enabled = 1
	let g:syntastic_java_javac_delete_output = 0
	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 1
	let g:syntastic_check_on_wq = 0

    Plug 'benekastah/neomake'
    let g:neomake_java_enabled_makers = ['javac']
    nnoremap ,b :Neomake<cr>

	Plug 'inside/vim-search-pulse'
    let g:vim_search_pulse_mode = 'pattern'
    let g:vim_search_pulse_disable_auto_mappings = 1
    let g:vim_search_pulse_color_list = ["red", "white"]
    let g:vim_search_pulse_duration = 200
    nmap n n<Plug>Pulse
    nmap N N<Plug>Pulse

	Plug 'ryanoasis/vim-devicons'
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

nnoremap <silent> <C-L> :nohlsearch<CR>

filetype plugin indent on
syntax enable

" Never insert <CR> if there are completions
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

" Java
augroup java_auto_commands
	autocmd FileType java,jsp set omnifunc=javacomplete#Complete
	" fast build (usually followed by running the program)
	autocmd Filetype java,jsp no <S-F10> :wa<CR> :!mvn install -P fastest -pl core -am<cr>
	" run unit tests
	autocmd Filetype java,jsp no <S-F11> :wa<CR> :!mvn test -P skipUITests -pl core -am<cr>
	" run integration tests
	autocmd Filetype java,jsp no <S-F12> :wa<CR> :!mvn verify -DskipITTests=false -P skipUITests -pl core -am<cr>
augroup END

let g:java_highlight_all = 1
let g:java_highlight_debug = 1
let g:java_space_errors = 1
let g:java_highlight_functions = 1
let g:java_allow_cpp_keywords = 1
autocmd FileType java nnoremap <F5> :call javacomplete#imports#Add()<CR>
autocmd FileType java nnoremap <F6> :call javacomplete#imports#RemoveUnused()<CR>
autocmd FileType java nnoremap <F7> :call javacomplete#imports#AddMissing()<CR>

nnoremap Y y$
nnoremap ,so :<C-u>source $MYVIMRC<CR>
nnoremap ,rc :<C-u>edit $MYVIMRC<CR>

" Open help files in new tab
autocmd BufEnter *.txt if &buftype == 'help' | silent wincmd T | endif

" Plug
nnoremap <silent> ,pc :<C-u>PlugClean<CR>
nnoremap <silent> ,pd :<C-u>PlugDiff<CR>
nnoremap <silent> ,pi :<C-u>PlugInstall<CR>
nnoremap <silent> ,ps :<C-u>PlugStatus<CR>
nnoremap <silent> ,pu :<C-u>PlugUpdate<CR>

" When a window is entered, set nowrap (so nowrap is honored even in splits)
au! WinEnter * set nowrap
