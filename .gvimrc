let s:vim_dir = ''
if has('win32') || has('win64')
    let s:vim_dir = $HOME . '/vimfiles'
else
    let s:vim_dir = $HOME . '/.vim'
endif

source s:vim_dir . '/.vimrc'

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
