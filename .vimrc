source $VIMRUNTIME/defaults.vim
set nocompatible
set number
set tabstop=4
set virtualedit+=onemore
set visualbell " prevents the annoying bell
set shiftwidth=4 " this enables < and > to have 4 space width
set hlsearch
set showcmd " shows command in bottom right corner of screen
syntax on
command Hl :set hlsearch! " use :Hl to toggle highlight
set matchpairs+=<:>
filetype plugin indent on
packadd! matchit
set incsearch
set viminfo='9999,f1
au Filetype java map \p iSystem.out.println();<Esc>hi
au Filetype cpp map \p istd::cout << ;<Esc>i
au Filetype js map \p iconsole.log()<Esc>i
au Filetype python map \p iprint()<Esc>i
au Filetype awk map\p iprint 
