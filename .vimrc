source $VIMRUNTIME/defaults.vim
set number
set tabstop=4
set virtualedit+=onemore
set visualbell " prevents the annoying bell
set shiftwidth=4 " this enables < and > to have 4 space width
set nohlsearch
set showcmd " shows command in bottom right corner of screen
syntax on
command Hl :set hlsearch! " use :Hl to toggle highlight
command Sp :set spell! " use :Sp to toggle spell on and off
set matchpairs+=<:>
filetype plugin indent on
packadd! matchit
set incsearch
set viminfo='9999,f1
set laststatus=2
set stl+=%{ConflictedVersion()} " allow to see version name in statusbar

nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
set splitbelow
set splitright
" this does not work without the papercolor plugin
" --------------------
colorscheme PaperColor
" this is all stuff related to vim-javacomplete2
" ----------------------------------------------
autocmd FileType java setlocal omnifunc=javacomplete#Complete
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
nmap <F5> <Plug>(JavaComplete-Imports-Add)
imap <F5> <Plug>(JavaComplete-Imports-Add)
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
" this is all stuff for DelimitMate
" ----------------------------------
let delimitMate_balance_matchpairs = 0
let delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_expand_cr = 1

au Filetype java nnoremap \p aSystem.out.println();<Esc>hi
au Filetype java nnoremap \m ipublic class Main {<ENTER>public static void main(String[] args) {<ENTER>System.out.println("Hello world");<ENTER>}<ENTER>}<Esc>4k2wviw
au Filetype cpp nnoremap \p astd::cout << ;<Esc>i
au Filetype js nnoremap \p aconsole.log()<Esc>i
au Filetype python nnoremap \p aprint()<Esc>i
au Filetype awk nnoremap\p aprint 
au Filetype sh nnoremap \p aecho 
au FileType perl nnoremap\m i#!/usr/bin/perl<ENTER>
au FileType text setlocal spell spelllang=en_us
" here is the shame section, this is all stuff I just copy and pasted without
" understading
set t_ut= " this fixes the background color scrolling issue
