" vim: foldmethod=marker
if !has('nvim') && has('vim_starting')
    set encoding=utf-8
endif

if !has('nvim')
    set ttyfast
    set visualbell t_vb=
    set t_Co=256
else
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

set shortmess+=c
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
set tm=500
set showcmd
set noshowmode
set autoread
set fileformats+=mac
set history=10000
set nostartofline
set wildmode=list:longest
set wildignore+=*/tmp/*,*/target/*,*.so,*.swp,*.zip,*.class,*.jar,*.exe
set wildignore+=*DS_Store*,.idea/**,.git,.gitkeep,*.png,*.jpg,*.gif
set list
set listchars=tab:▸\ ,trail:·,extends:»,precedes:«,nbsp:⎵
set smartindent
set shiftround
set splitright
set nowrap
set completeopt=longest,menuone
set mouse=a
set tabpagemax=50
set timeoutlen=3000

let s:vim_dir = ''
let s:is_win = 0
if has('win32') || has('win64')
    let s:vim_dir = $HOME . '/vimfiles'
    let s:is_win = 1
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

function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [] })
endfunction

call plug#begin(s:vim_dir . '/bundle')
    Plug 'morhetz/gruvbox'
    " Make ctrl-p ignore files in .gitignore
    let g:ctrlp_working_path_mode = 'raw'
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    let g:airline_powerline_fonts = 1
    Plug 'vim-airline/vim-airline-themes'
    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_theme = 'papercolor'

    Plug 'majutsushi/tagbar'
    noremap <silent> <F2> :TagbarToggle<CR>

    let g:JavaComplete_UsePython3 = 1
    Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }

    " Better java.vim syntax highlighting
    Plug 'rudes/vim-java', { 'for' : 'java' }
    Plug 'NLKNguyen/vim-maven-syntax', { 'for': 'xml.maven' }

    Plug 'Shougo/deoplete.nvim', Cond(has('nvim'))

    Plug 'zchee/deoplete-clang', Cond(has('nvim'), { 'for': ['c', 'cpp'] })
    let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
    let g:deoplete#sources#clang#clang_header ="/usr/include/clang/"

    Plug 'zchee/deoplete-jedi', Cond(has('nvim'), { 'for': 'python' })

    Plug 'benekastah/neomake', Cond(has('nvim'), { 'on': 'Neomake' })
    Plug 'Valloric/YouCompleteMe', Cond(!has('nvim'), { 'do': 'python install.py --clang-completer --tern-completer' })

    Plug 'scrooloose/syntastic', Cond(!has('nvim'))
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_error_symbol = '✗'
    let g:syntastic_warning_symbol = '⚠'
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_wq = 0

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

if has('gui_running')
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

    if has('gui_gtk2')
        set guifont=Inconsolata\ 12
    elseif has('gui_macvim')
        set guifont=Menlo\ Regular:h14
    elseif has('gui_win32')
        set guifont=DejaVu_Sans_Mono_for_Powerline:h11:cANSI
        if has('directx')
            set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
        endif
  endif
endif

" Never insert <CR> if there are completions
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

" Put deleted empty lines into the blackhole register (not the last-yank
" register)
nnoremap <expr> dd empty(getline('.')) ? '"_dd' : 'dd'

nnoremap Y y$
nnoremap ,so :<C-u>source $MYVIMRC<CR>
nnoremap ,rc :<C-u>edit $MYVIMRC<CR>

" Open help files in new tab
autocmd BufEnter *.txt if &buftype == 'help' | silent wincmd T | endif

" Window navigation
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
if has('nvim')
    tnoremap <A-Left> <C-\><C-n><C-w>h
    tnoremap <A-Down> <C-\><C-n><C-w>j
    tnoremap <A-Up> <C-\><C-n><C-w>k
    tnoremap <A-Right> <C-\><C-n><C-w>l
endif

" Sane clipboard settings
if has('unnamedplus')
    set clipboard^=unnamedplus
else
    set clipboard^=unnamed
endif

" statusline{{{
if 0 
hi User1 ctermfg=4 guifg=#40ffff  " Identifier
hi User5 ctermfg=10 guifg=#80a0ff " Comment

function! Slash()
    if s:is_win == 1
        return '\'
    else
        return '/'
    endif
endfunction

set statusline=
set statusline+=%5*%{expand('%:h')}     " Relative path to file dir
set statusline+=%{Slash()}%*
set statusline+=%1*%t%*                 " file name
set statusline+=%2*\ %{strlen(&ft)?&ft:'none'}
set statusline+=\ [%{&fileformat}]
set statusline+=\ %{&encoding}
set statusline+=\ %{fugitive#statusline()}
set statusline+=\ ==\ %l/%L             " cursor line/total lines
set statusline+=\ (%c)\                 " cursor column
"}}}
endif

" vim-plug mappings{{{
nnoremap <silent> ,pc :<C-u>PlugClean<CR>
nnoremap <silent> ,pf :<C-u>PlugClean!<CR>
nnoremap <silent> ,pd :<C-u>PlugDiff<CR>
nnoremap <silent> ,pi :<C-u>PlugInstall<CR>
nnoremap <silent> ,ps :<C-u>PlugStatus<CR>
nnoremap <silent> ,pu :<C-u>PlugUpdate<CR>
nnoremap <silent> ,pn :<C-u>PlugUpgrade<CR>
" }}}

" When a window is entered, set nowrap (so nowrap is honored even in splits)
au! WinEnter * set nowrap

autocmd FileType gitcommit highlight ColorColumn ctermbg=241 guibg=#2b1d0e
autocmd FileType gitcommit let &colorcolumn=join(range(72,999),",")

" Java{{{
autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType java let b:vcm_tab_complete = 'omni'
autocmd FileType java highlight ColorColumn ctermbg=241 guibg=#2b1d0e
autocmd FileType java let &colorcolumn=join(range(120,999),",")
autocmd FileType java setlocal tabstop=4 shiftwidth=4 expandtab copyindent softtabstop=0
autocmd FileType java setlocal makeprg=mvn
autocmd FileType java setlocal errorformat=[%tRROR]\ %f:[%l]\ %m,%-G%.%#
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
let g:java_highlight_all = 1
let g:java_highlight_debug = 1
"let g:java_space_errors = 1
let g:java_highlight_functions = 1
let g:java_allow_cpp_keywords = 1

let g:neomake_java_enabled_makers = ['javac']
let g:neomake_mvn_args = ['package', '-pl', 'core', '-P', 'fastest', '-T', '2']

if exists("g:loaded_dispatch")
    autocmd Filetype java nnoremap <S-F10> :Make install -P fastest -pl core -am -T 0.5C<cr>
else
    autocmd Filetype java nnoremap <S-F10> :make install -P fastest -pl core -am -T 0.5C<cr>
endif

au BufRead,BufNewFile *.fxml set filetype=xml
"}}}
