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
set matchpairs+=<:>
filetype plugin indent on
packadd! matchit
set incsearch
set viminfo='9999,f1

nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
set splitbelow
set splitright

au Filetype java nnoremap \p iSystem.out.println();<Esc>hi
au Filetype java nnoremap \m ipublic class Main {<ENTER>public static void main(String[] args) {<ENTER>System.out.println("Hello world");<ENTER>}<ENTER>}<Esc>gg2wviw
au Filetype cpp nnoremap \p istd::cout << ;<Esc>i
au Filetype js nnoremap \p iconsole.log()<Esc>i
au Filetype python nnoremap \p iprint()<Esc>i
au Filetype awk nnoremap\p iprint 
au Filetype sh nnoremap \p iecho 
