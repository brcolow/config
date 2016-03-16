
" vim: foldmethod=marker
set nocompatible
set shortmess+=c
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
set smarttab
set complete-=i
set laststatus=2
set number
set noerrorbells
set visualbell t_vb=
set tm=500
set showcmd
set noshowmode
set autoread
set fileformats+=mac
set history=10000
set nostartofline
set wildmode=list:longest
set wildignore+=*/tmp/*,*/target/*,*.so,*.swp,*.zip,*.class,*.jar,*.exe
set list
set listchars=tab:»-,trail:·,extends:>,precedes:<,nbsp:¤
set smartindent
set shiftround
set splitright
set nowrap
set completeopt=longest,menuone
set clipboard=unnamed
set mouse=a
set tabpagemax=50
set timeoutlen=3000
set t_Co=256

let s:vim_dir = ''
if has('win32') || has('win64')
    let s:vim_dir = $HOME . '/vimfiles'
else
    let s:vim_dir = $HOME . '/.vim'
endif

" backup{{{
set backup
if (&backup)
    let s:vim_backup_dir = s:vim_dir . '/backup'
    set backupext=.bak
    let &backupdir=s:vim_backup_dir

    if !isdirectory(s:vim_backup_dir) && exists('*mkdir') " create backup directory INE
        call mkdir(s:vim_backup_dir, 'p', 0700)
    endif
endif
"}}}

" swap{{{
set swapfile
if (&swapfile)
    let s:vim_swap_dir = s:vim_dir . '/swap//'
    let &directory=s:vim_swap_dir

    if !isdirectory(s:vim_swap_dir) && exists('*mkdir') " create swap directory INE
        call mkdir(s:vim_swap_dir, 'p', 0700)
    endif
endif
"}}}

" undo{{{
if has("persistent_undo")
    set undofile
    let s:vim_undo_dir = s:vim_dir . '/undo//'
    let &undodir=s:vim_undo_dir

    if !isdirectory(s:vim_undo_dir) && exists('*mkdir') " create undo directory INE
        call mkdir(s:vim_undo_dir, 'p', 0700)
    endif
endif
"}}}

if empty(glob(s:vim_dir . '/autoload/plug.vim'))
execute 'silent !curl -fLo ' . shellescape(s:vim_dir . '/autoload/plug.vim') . ' --create-dirs '
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(s:vim_dir . '/bundle')
    Plug 'morhetz/gruvbox'
    " Make ctrl-p ignore files in .gitignore
    let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tabline#enabled = 1

    Plug 'majutsushi/tagbar'
    noremap <silent> <F2> :TagbarToggle<CR>

    if exists('g:vimplugin_running')
        " eclim is running
    endif
    Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }

    " Better java.vim syntax highlighting
    Plug 'rudes/vim-java', { 'for' : 'java' }
    Plug 'ajh17/VimCompletesMe'
    " let g:ycm_path_to_python_interpreter="C:\\Python27\\python.exe"
    " Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py --clang-completer --tern-completer' }
    " let g:ycm_semantic_triggers =  { 'java,jsp' : ['::'] } " You cannot remove the default triggers, only add new ones.
    " let g:ycm_collect_identifiers_from_tags_files = 1

    " Plug 'scrooloose/syntastic'
    " let g:syntastic_java_javac_config_file_enabled = 1
    " let g:syntastic_java_javac_delete_output = 0
    " let g:syntastic_always_populate_loc_list = 1
    " let g:syntastic_auto_loc_list = 1
    " let g:syntastic_check_on_open = 1
    " let g:syntastic_check_on_wq = 0

    Plug 'inside/vim-search-pulse'
    let g:vim_search_pulse_mode = 'pattern'
    let g:vim_search_pulse_disable_auto_mappings = 1
    let g:vim_search_pulse_color_list = ["red", "white"]
    let g:vim_search_pulse_duration = 200
    nmap n n<Plug>Pulse
    nmap N N<Plug>Pulse

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

nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

filetype plugin indent on
syntax enable

if executable('pt')
    let &grepprg = 'pt --nogroup --nocolor'
    let g:ctrlp_user_command = ['pt --nocolor -g "\\*" %s']
elseif executable('ag')
    let &grepprg = 'ag --vimgrep $*'
    let &grepformat=%f:%l:%c:%m
    let g:ctrlp_user_command = ['ag %s -f -l --nocolor -g "" --hidden --ignore .git']
endif

if has("gui_running")
    " width of gvim
    setglobal columns=230
    " height of gvim
    setglobal lines=55
    " Hide toolbar and menus.
    setglobal guioptions-=Tt
    setglobal guioptions-=m
    " Scrollbar is always off.
    setglobal guioptions-=rL
    " Not guitablabel.
    setglobal guioptions-=e
    " Confirm without window.
    setglobal guioptions+=c
    let g:gruvbox_italic = 0
    colorscheme gruvbox
    set bg=dark

    let g:airline_powerline_fonts = 0

    if has("gui_gtk2")
        set guifont=Inconsolata\ 12
    elseif has("gui_macvim")
        set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
        set guifont=Bitstream_Vera_Sans_Mono:h11:cANSI
  endif
else
    let g:airline_powerline_fonts = 1
endif

" Never insert <CR> if there are completions
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

nnoremap Y y$
nnoremap ,so :<C-u>source $MYVIMRC<CR>
nnoremap ,rc :<C-u>edit $MYVIMRC<CR>

" Open help files in new tab
autocmd BufEnter *.txt if &buftype == 'help' | silent wincmd T | endif

" (Faster) window movements (press tab to cycle through windows, alt + direction to move windows)
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
nnoremap <silent><expr> <tab> (v:count > 0 ? '<c-w>w' : ':<C-u>call <sid>switch_to_alt_win()<cr>')
xmap <silent> <tab> <esc><tab>

" go to the previous window (or any other window if there is no 'previous' window).
func! s:switch_to_alt_win()
  let currwin = winnr()
  wincmd p
  if winnr() == currwin "window didn't change, so there was no 'previous' window.
    wincmd W
  endif
endf

" vim-plug mappings{{{
nnoremap <silent> ,pc :<C-u>PlugClean<CR>
nnoremap <silent> ,pd :<C-u>PlugDiff<CR>
nnoremap <silent> ,pi :<C-u>PlugInstall<CR>
nnoremap <silent> ,ps :<C-u>PlugStatus<CR>
nnoremap <silent> ,pu :<C-u>PlugUpdate<CR>
" }}}

" When a window is entered, set nowrap (so nowrap is honored even in splits)
au! WinEnter * set nowrap

autocmd FileType gitcommit highlight ColorColumn ctermbg=241 guibg=#2b1d0e
autocmd FileType gitcommit let &colorcolumn=join(range(72,999),",")

" Java{{{
" if exists('g:vimplugin_running')
    " autocmd FileType java let g:EclimCompletionMethod = 'omnifunc'
" else
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
" endif
autocmd FileType java let b:vcm_tab_complete = 'omni'
autocmd FileType java highlight ColorColumn ctermbg=241 guibg=#2b1d0e
autocmd FileType java let &colorcolumn=join(range(120,999),",")
autocmd FileType java setlocal tabstop=4 shiftwidth=4 expandtab copyindent softtabstop=0
autocmd FileType java setlocal makeprg=mvn
autocmd FileType java setlocal errorformat=[%tRROR]\ %f:[%l]\ %m,%-G%.%#

let g:neomake_java_enabled_makers = ['javac']
let g:neomake_mvn_args = ['package', '-pl', 'core', '-P', 'fastest', '-T', '2']

if exists("g:loaded_dispatch")
    autocmd Filetype java nnoremap <S-F10> :Make install -P fastest -pl core -am -T 0.5C<cr>
else
    autocmd Filetype java nnoremap <S-F10> :make install -P fastest -pl core -am -T 0.5C<cr>
endif

au BufRead,BufNewFile *.fxml set filetype=xml
"}}}
