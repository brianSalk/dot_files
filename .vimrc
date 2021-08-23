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
" FIX ME: might not have to unset formatoptions
function! Wrap_selection(beg,_end,indent)
	" move to begining of last highlghted section
	'<
	" read top line into first_line
	let first_line= getline('.')
	if line('.') == 1
		let had_c=0
		let had_r=0
		let had_o=0
		if &formatoptions =~ 'c'
			let had_c=1
			set formatoptions-=c
		endif
		if &formatoptions =~ 'r'
			let had_r=1
			set formatoptions-=r
		endif
		if &formatoptions =~ 'o'
			let had_o=1
			set formatoptions-=o
		endif
		:normal O
		if had_c
			set formatoptions+=c
		endif
		if had_r
			set formatoptions+=r
		endif
		if had_o
			set formatoptions+=o
		endif
	

	endif
	let indent_space = matchstr(first_line,'\s*') " greedy regex will extract all the spaces from the begining of the line
	let beg = indent_space . a:beg
	:normal k
	put= beg
	'>

	let _end = indent_space . a:_end
	put= _end
	if a:indent
		:normal '<>'>
	endif

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
set nofoldenable
set updatetime=100 " holding cursor over word for 1/10 second displays the info
command Err YcmShowDetailedDiagnostic
" remove all spaces and newlines from selected text, very useful for copy
" +and pasted fasta files.
vnoremap \1 <ESC>:'<,'>s/\s\\|\n//g<ENTER> 

augroup filetype_cpp_java
	autocmd!
	au Filetype cpp,java vnoremap \tt <ESC>:call Wrap_selection("try {", "} catch() {}",1)<ENTER>'>j$i<ENTER><ESC>kt)a
	au Filetype cpp,java vnoremap \ti <ESC>:call Wrap_selection("if (true) {","}",1)<ENTER>'<k_ftciw
	au Filetype cpp,java vnoremap \tw <ESC>:call Wrap_selection("while (true) {","}",1)<ENTER>'<k_ftciw
	au Filetype cpp,java vnoremap \tc <ESC>'<i/*<ESC>'>$a*/<ESC>
	au FileType cpp,java nnoremap \tc _i/*<ESC>$a*/<ESC>
augroup END
" language specific shortcuts -------------------------
"augroup filetype_java
augroup filetype_vim
	autocmd!
	au Filetype vim vnoremap \ta <ESC>:call Wrap_selection("augroup \n\tautocmd!","augroup END",1)<ENTER>'<2kA
	"au Filetype vim nnoremap \ta V><ESC>'<Oaugroup<ESC>:s/^\(\s*\)\(\"\)\?/\1/<ENTER>o<TAB>autocmd!<ESC>'>oaugroup END<ESC>'<<ESC>2kea 
	au Filetype vim vnoremap \ti <ESC>:call Wrap_selection("if ","endif",1)<ENTER>'<kA
augroup END

augroup filetype_java
	autocmd!
	au Filetype java nnoremap \p aSystem.out.println();<Esc>hi
	au Filetype java nnoremap \m ipublic class <ESC>"%pF.c2w {<ENTER>public static void main(String[] args) {<ENTER>System.out.println("Hello world");<ENTER>}<ENTER>}<Esc>2kll
augroup END
augroup filetype_c
	autocmd!
	au Filetype c nnoremap \m a#include <stdio.h><ENTER><ENTER>int main(int argc, char* argv[]) {<ENTER>}<ESC>ko
augroup END
augroup filetype_js
	autocmd!
	au Filetype js nnoremap \p aconsole.log()<Esc>i
augroup END
augroup filetype_python 
	autocmd!
	au Filetype python nnoremap \p aprint()<Esc>i
	au Filetype python vnoremap \ti :call Wrap_selection("if :","",1)<ENTER>
	au Filetype python vnoremap \tt <ESC>:call Wrap_selection("try:","except :",1)<ENTER>'>j$i
augroup END
augroup filetype_awk
	autocmd!
	au Filetype awk nnoremap\p aprint 
augroup END
augroup filetype_bash
	autocmd!
	au Filetype sh nnoremap \p aecho 
augroup END
augroup filetype_perl
	autocmd!
	au FileType perl nnoremap\m i#!/usr/bin/perl<ENTER>
augroup END
augroup filetype_plaintex
	autocmd!
	au FileType plaintex nnoremap \p pggi\documentclass{article}<ENTER>\begin{document}<ENTER>\end{document}<ESC>O
augroup END
au FileType text setlocal spell spelllang=en_us
augroup filetype_cpp 
	autocmd!
	au Filetype cpp nnoremap \p astd::cout << ;<Esc>i
	au Filetype cpp nnoremap \m a#include <iostream><ENTER><ENTER>int main(int argc, char* argv[]) {<ENTER>std::cout << "" << '\n';<ENTER>}<ESC>kf"a
	au FileType cpp vnoremap \c <Esc>:'<,'>s/^/\/\//<ENTER>
	au Filetype cpp nnoremap \c <Esc>:s/^/\/\//<ENTER>
	au FileType cpp vnoremap \u <Esc>:'<,'>s/^\(\s\)*\/\{2,\}/\1/<ENTER>
	au Filetype cpp nnoremap \T	atemplate <typename ><Esc>i
	au BufNewFile main.cpp :normal\m
augroup END
augroup filetype_all
	autocmd!
	au FileType * set foldmethod=syntax " when the filetype is known, create folds based on syntax, otherwise they are created manually
augroup END
" here is the shame section, this is all stuff I just copy and pasted without
" understading
set t_ut= " this fixes the background color scrolling issue somehow
let &t_SI = "\e[6 q" " this makes my cursor look normal even in my shell changes it
