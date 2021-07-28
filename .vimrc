source $VIMRUNTIME/defaults.vim
" define functions ------
function Toggle_ycm_auto_hover()
	if g:ycm_auto_hover == 'CursorHold'
		let g:ycm_auto_hover = ''
	else
		let g:ycm_auto_hover = 'CursorHold'
	endif
	YcmRestartServer
endfunction
" -----------------------
set number
set scrolloff=0 " ensure that pressing L and H puts cursor at top/bottom of screen
set tabstop=4
set virtualedit+=onemore
set visualbell " prevents the annoying bell
set shiftwidth=4 " this enables < and > to have 4 space width
set nohlsearch " do not highlight searches by default
set showcmd " shows command in bottom right corner of screen
syntax on
" YcmShowDetailedDiagnostic alias
command Hl :set hlsearch! " use :Hl to toggle highlight
command Sp :set spell! " use :Sp to toggle spell on and off
command Ac :call Toggle_ycm_auto_hover() " press :Ac to toggle YCM's auto popup
set matchpairs+=<:>
filetype plugin indent on
packadd! matchit
set incsearch
set viminfo='9999,f1
set laststatus=2
set stl+=%{ConflictedVersion()} " allow to see version name in statusbar
set completeopt-=preview

nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
set splitbelow
set splitright
" this does not work without the papercolor plugin
" --------------------
set background=dark
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

" this stuff is related to YouCompleteMe
" -------------------------------------
set updatetime=100 " holding cursor over word for 1/10 second displays the info
command Err YcmShowDetailedDiagnostic
" remove all spaces and newlines from selected text, very useful for copy
" +and pasted fasta files.
au FileType * vnoremap \1 <Esc>:'<,'>s/\s\\|\n//g<ENTER> 
" language specific shortcuts -------------------------
au Filetype java nnoremap \p aSystem.out.println();<Esc>hi
au Filetype java nnoremap \m ipublic class <ESC>"%pF.c2w {<ENTER>public static void main(String[] args) {<ENTER>System.out.println("Hello world");<ENTER>}<ENTER>}<Esc>2kll
au Filetype cpp nnoremap \p astd::cout << ;<Esc>i
au Filetype cpp nnoremap \m a#include <iostream><ENTER><ENTER>int main(int argc, char* argv[]) {<ENTER>std::cout << "" << '\n';<ENTER>}<ESC>kEEEi
au Filetype c nnoremap \m a#include <stdio.h><ENTER><ENTER>int main(int argc, char* argv[]) {<ENTER>}<ESC>ko
au Filetype js nnoremap \p aconsole.log()<Esc>i
au Filetype python nnoremap \p aprint()<Esc>i
au Filetype awk nnoremap\p aprint 
au Filetype sh nnoremap \p aecho 
au FileType perl nnoremap\m i#!/usr/bin/perl<ENTER>
au FileType plaintex nnoremap \p pggi\documentclass{article}<ENTER>\begin{document}<ENTER>\end{document}<ESC>O
au FileType text setlocal spell spelllang=en_us
au FileType cpp vnoremap \c <Esc>:'<,'>s/^/\/\//<ENTER>
au Filetype cpp nnoremap \c <Esc>:s/^/\/\//<ENTER>
" here is the shame section, this is all stuff I just copy and pasted without
" understading
set t_ut= " this fixes the background color scrolling issue somehow
