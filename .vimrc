" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
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

" nvim is better. change my mind
if !has('nvim')
  set ttymouse=xterm2
endif

" for moar colors
syntax on
filetype plugin on

" because I can't live without enabling it
set number
set ruler

" indentation
set tabstop=2
set shiftwidth=2

" encoding for making lives easier
set encoding=utf-8

" hide statusbar. I don't like it. change my mind
set laststatus=0

" yank to clipboard
set clipboard=unnamedplus

" better search imo
set ignorecase
set smartcase

" maps esc to go to normal mode while in :term
tnoremap <Esc> <C-\><C-n>       

" set 256 colors
set t_Co=256

" keybindings
nmap <F6> :NERDTreeToggle<CR>

" Plugins start here
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Own plugins
" General
Plugin 'jiangmiao/auto-pairs'
Plugin 'scrooloose/nerdtree'
Plugin 'davidhalter/jedi-vim' "because python
Plugin 'jistr/vim-nerdtree-tabs' " I lke me some fancy stuff
Plugin 'vim-syntastic/syntastic' " it saves me some time
Plugin 'ervandew/supertab' " using tab for completion is better

" Beautify. everyone expects their to be noice looking
Plugin 'ryanoasis/vim-devicons'
Plugin 'ryanoasis/vim-webdevicons'
Plugin 'morhetz/gruvbox'
Plugin 'vim-scripts/twilight256.vim'
" no vimairline for ya

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" colorscheme
colorscheme twilight256

" Plugin's config

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

