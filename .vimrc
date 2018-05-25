" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim80/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

" do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1

" Omnicompletion
filetype plugin on
set omnifunc=syntaxcomplete#Complete<Paste>

if !has('nvim')
  set ttymouse=xterm2
endif

syntax on
set encoding=UTF-8 
set number
autocmd VimEnter * NERDTree
autocmd ColorScheme * highlight Normal ctermbg=NONE
" maps esc to close terminal
tnoremap <Esc> <C-\><C-n>       

hi Normal ctermbg=none
colorscheme afterglow

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


" load plugin using vundle
" Programming
Plugin 'jiangmiao/auto-pairs'
Plugin 'Townk/vim-autoclose'
Plugin 'scrooloose/nerdtree'
Plugin 'davidhalter/jedi-vim'
Plugin 'ervandew/supertab'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-syntastic/syntastic'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-scripts/a.vim'
Plugin 'jez/vim-c0'
Plugin 'jez/vim-ispc'
Plugin 'kchmck/vim-coffee-script'

" Beautify
Plugin 'ryanoasis/vim-devicons'
Plugin 'ryanoasis/vim-webdevicons'
Plugin 'rafi/awesome-vim-colorschemes'
Plugin 'danilo-augusto/vim-afterglow'
Plugin 'miyakogi/seiya.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'morhetz/gruvbox'

" General Plugins
Plugin 'easymotion/vim-easymotion'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1 
let g:airline_theme= 'dracula'
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 

"devicons

let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_enable_ctrlp = 1

"syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"jedi-vim
let g:jedi#completions_command = "<C-Tab>"

" yank to clipboard
set clipboard=unnamed
"function! ClipboardYank()
"  call system('xclip -i -selection clipboard', @@)
"endfunction
"function! ClipboardPaste()
"  let @@ = system('xclip -o -selection clipboard')
"endfunction
"
"vnoremap <silent> y y:call ClipboardYank()<cr>
"vnoremap <silent> d d:call ClipboardYank()<cr>
"nnoremap <silent> p :call ClipboardPaste()<cr>p
" shortcuts
nmap <F6> :NERDTreeToggle<CR>
