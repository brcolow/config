" vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
if !has('nvim') && has('vim_starting')
  set encoding=utf-8
endif

if !has('nvim')
  set ttyfast
else
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
  set termguicolors
  let g:python3_host_prog = '/usr/bin/python3'
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
set fileformats=unix,dos
set history=10000
set nostartofline
set wildmode=list:longest
set wildignore+=*/tmp/*,*/target/*,*.so,*.swp,*.zip,*.class,*.jar,*.exe
set wildignore+=*DS_Store*,.idea/**,.git,.gitkeep,*.png,*.jpg,*.gif
set wildignore+=*.o
set wildignore+=*/node_modules/**
set wildignore+=*/bower_components/**
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
set visualbell t_vb=
if has('nvim-0.2.0')
  set inccommand=split
endif


let s:vim_dir = ''
let s:is_win = 0
if has('win32') || has('win64')
  let s:vim_dir = $HOME . '/vimfiles'
  let s:is_win = 1
else
  if has('nvim')
    let s:vim_dir = $HOME . '/.config/nvim'
  else
    let s:vim_dir = $HOME . '/.vim'
  endif
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

function! CycleNumbering() abort
  " (off number relativenumber)
  if &number && !&relativenumber
    setlocal relativenumber
  elseif &relativenumber
    setlocal norelativenumber
    setlocal nonumber
  else
    setlocal number
  endif
endfunction

nnoremap <silent> <Space>n :call CycleNumbering()<CR>

if empty(glob(s:vim_dir . '/autoload/plug.vim'))
  execute 'silent !curl -fLo ' . shellescape(s:vim_dir . '/autoload/plug.vim') . ' --create-dirs '
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

function! Cond(cond, ...) abort
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [] })
endfunction

call plug#begin(s:vim_dir . '/bundle')
    Plug 'joshdick/onedark.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

    let g:gutentags_cache_dir = s:vim_dir . '/tags'
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
    let g:airline#extensions#neomake#enabled = 0
    let g:airline_theme = 'onedark'

    Plug 'mhinz/vim-grepper'
    nnoremap <silent> <Space>g :Grepper -tool ag -switch<cr>
    let g:tagbar_sort = 0
    Plug 'majutsushi/tagbar'
    noremap <silent> <F2> :TagbarToggle<CR>

    let g:localvimrc_sandbox = 0
    let g:localvimrc_debug = 1
    let g:localvimrc_persistent = 1
    let g:localvimrc_name = [".lvimrc", "contrib/.lvimrc"]
    " Plug 'embear/vim-localvimrc'
    " let g:JavaComplete_UsePython3 = 1
    " Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }

    " Better java.vim syntax highlighting
    Plug 'rudes/vim-java', { 'for': 'java' }
    Plug 'NLKNguyen/vim-maven-syntax', { 'for': 'xml.maven' }
    Plug 'keith/swift.vim', { 'for': 'swift' }

    let g:deoplete#enable_at_startup = 1
    let g:deoplete#auto_complete_start_length = 1
    Plug 'Shougo/deoplete.nvim', Cond(has('nvim'))

    let g:deoplete#sources#clang#libclang_path = "/usr/lib/llvm-3.4/lib/libclang.so"
    let g:deoplete#sources#clang#clang_header = "/usr/include/clang/3.4/include"
    Plug 'zchee/deoplete-clang', Cond(has('nvim'), { 'for': ['c', 'cpp'] })
    Plug 'zchee/deoplete-jedi', Cond(has('nvim'), { 'for': 'python' })
    Plug 'carlitux/deoplete-ternjs', Cond(has('nvim'), { 'for': ['javascript', 'javascript.jsx'] })
    let g:deoplete#sources = {}
    let g:deoplete#sources.javascript = ['ternjs']

    let g:neomake_open_list = 2
    Plug 'neomake/neomake', Cond(has('nvim'), { 'on': 'Neomake' })
    let g:neomake_javascript_enabled_makers = ['eslint']
    let g:neomake_javascript_eslint_maker = {
        \ 'args': ['--no-color', '--format', 'compact']
        \ }
    let g:neomake_java_enabled_makers = ['javac']
    let g:neomake_sass_enabled_makers = ['sass-lint']
    let g:neomake_sql_enabled_makers = ['sqlint']
    let g:neomake_sh_enabled_makers = ['shellcheck']
    let g:neomake_ansible_enabled_makers = ['ansiblelint']

    Plug 'othree/yajs.vim', { 'for': 'javascript' }
    Plug 'inside/vim-search-pulse'
    let g:vim_search_pulse_mode = 'pattern'
    let g:vim_search_pulse_disable_auto_mappings = 1
    let g:vim_search_pulse_color_list = ["red", "white"]
    let g:vim_search_pulse_duration = 200
    nmap n n<Plug>Pulse
    nmap N N<Plug>Pulse
    Plug 'chase/vim-ansible-yaml'
    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-textobj-line' " (l)ine
    Plug 'kana/vim-textobj-function', { 'for': ['cpp', 'c', 'java', 'vim' ] } " (f)unction/method
    Plug 'gaving/vim-textobj-argument' " (a)rgument
    Plug 'mattn/vim-textobj-url' " (u)rl
call plug#end()

if has('mac')
    set background=light " or dark
    colorscheme solarized
else
    colorscheme onedark
endif

nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

filetype plugin indent on
syntax enable

" Remember last cursor position.
if line("'\"") > 1 && line("'\"") <= line('$')
  " Unless it's a commit message.
  if &filetype !=# 'gitcommit'
    exe "normal! g'\""
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
  tnoremap <esc> <c-\><c-n>
  tnoremap <A-Left> <C-\><C-n><C-w>h
  tnoremap <A-Down> <C-\><C-n><C-w>j
  tnoremap <A-Up> <C-\><C-n><C-w>k
  tnoremap <A-Right> <C-\><C-n><C-w>l
endif

nnoremap <expr><silent> \| !v:count ? "<C-W>v<C-W><Right>" : '\|'
nnoremap <expr><silent> _  !v:count ? "<C-W>s<C-W><Down>"  : '_'

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
endif
"}}}

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

set spelllang=en_us
augroup gitcommit
  autocmd!
  autocmd FileType gitcommit setlocal spell textwidth=72
  autocmd FileType gitcommit highlight ColorColumn ctermbg=241 guibg=#2b1d0e
  autocmd FileType gitcommit let &colorcolumn=join(range(72,999),",")
augroup END

" Java{{{
augroup java
  autocmd!
  autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType java let b:vcm_tab_complete = 'omni'
  autocmd FileType java highlight ColorColumn ctermbg=241 guibg=#2b1d0e
  autocmd FileType java let &colorcolumn=join(range(120,999),",")
  autocmd FileType java setlocal tabstop=4 shiftwidth=4 expandtab copyindent softtabstop=0
  autocmd FileType java setlocal makeprg=mvn
  autocmd FileType java setlocal errorformat=[%tRROR]\ %f:[%l]\ %m,%-G%.%#
  autocmd FileType java nmap ,im <Plug>(JavaComplete-Imports-AddSmart)
augroup END
let g:java_highlight_all = 1
let g:java_highlight_debug = 1
let g:java_highlight_functions = 1
let g:java_allow_cpp_keywords = 1

au BufRead,BufNewFile *.fxml set filetype=xml
"}}}

" select buffer (fzf){{{
function! s:buflist() abort
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e) abort
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Space>b :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>
"}}}

nnoremap <silent> <Space>f :FZF<CR>

function! s:findNearestFile(files) abort
  lcd %:p:h
  let l:files = a:files
  if (type(l:files) != type([]))
    let l:files = [a:files]
  endif

  let l:found = ""
  for file in l:files
    let l:found = findfile(file, ".;")
    if l:found != ""
      break
    endif
  endfor

  if l:found == ""
    echom "could not find any file: " . string(l:files)
    return v:null
  else
    return l:found
  endif
endfunction

" Determine, based on cursor position, what function/method the cursor
" is currently inside of. Designed to work for Java-like languages.
function! s:whatFunctionAreWeIn() abort
  let strList = ["while",  "for", "if", "elseif", "else", "try", "catch", "finally", "case", "switch"]
  let foundcontrol = 1
  let position = ""
  let pos=getpos(".")
  let view=winsaveview()
  let funcName = ""
  while (foundcontrol)
    let foundcontrol = 0
    normal [{
    call search('\S','bW')
    let tempchar = getline(".")[col(".") - 1]
    if (match(tempchar, ")") >=0 )
      normal %
      call search('\S','bW')
    endif
    let tempstring = getline(".")
    let funcLineSplit = split(tempstring)
    for item in funcLineSplit
      if (stridx(item, "()") != -1)
        let funcName = item
        break
      endif
    endfor
    for item in strList
      if (match(tempstring,item) >= 0)
        let position = item . " - " . position
        let foundcontrol = 1
        break
      endif
    endfor
    if (foundcontrol == 0)
      call cursor(pos)
      call winrestview(view)
    endif
  endwhile
  call cursor(pos)
  call winrestview(view)
  return funcName[0:stridx(funcName, '()') - 1]
endfunction

" Get the (Java-like) class name of the currently opened file.
function! s:getClassName() abort
  return expand('%:r')[strridx(expand('%:r'), '/') + 1:]
endfunction

" Open a :terminal with the current working directory set to the nearest
" directory (searching upwards from the current directory) containing
" a:file and execute the given command in a:args.
function! s:openTerm(file, args) abort
  let cwd = getcwd()
  echom s:findNearestFile(a:file)
  echom a:args
  execute 'lcd ' . fnamemodify(s:findNearestFile(a:file), ':p:h')
  execute 'vsplit | terminal ' . a:args
  execute 'lcd ' . cwd
endfunction

command! -nargs=* -complete=file JUnitA call s:openTerm('pom.xml', 'mvn -Dtest=' . s:getClassName() . ' test ') . <args>)
nnoremap <silent> <Space>ta :JUnitA<cr>
command! -nargs=* -complete=file JUnitS call s:openTerm('pom.xml', 'mvn -Dtest=' . s:getClassName() . '#' . s:whatFunctionAreWeIn() . ' test ') . <args>)
nnoremap <silent> <Space>ts :JUnitS<cr>

command! -nargs=* -complete=file Gulp call s:openTerm(['gulpfile.babel.js', 'gulpfile.js'], 'gulp' . <args>)
nnoremap <silent> <Space>u :Gulp<cr>

let s:gitDir = system('git rev-parse --show-toplevel')
if !v:shell_error
  let s:gitDirString = split(s:gitDir)[0]
  if !empty(glob(s:gitDirString . '/package.json'))
    let g:neomake_javascript_eslint_exe = s:gitDirString .'/node_modules/.bin/eslint'
  endif
endif

