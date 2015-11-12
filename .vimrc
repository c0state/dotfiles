"----- General
  set autoread
  set nocompatible
  set visualbell
  set hlsearch
  set incsearch
  set tabstop=4
  set expandtab
  set showcmd
  set nobackup
  set number
  set wrap
  let mapleader=","
  set hidden
  set autoindent
  set shiftwidth=4
  set showmatch
  set pastetoggle=<F2>
"-----

"----- Vundle
  filetype off
  
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'
"-----

"----- Vundle Bundles
  Plugin 'editorconfig/editorconfig-vim'

  Plugin 'vim-scripts/vim-auto-save'
  let g:auto_save=1

  Plugin 'ghewgill/vim-scmdiff'
  Plugin 'kien/ctrlp.vim'
  Plugin 'Lokaltog/vim-powerline'
  Plugin 'Lokaltog/vim-easymotion'
  Plugin 'majutsushi/tagbar'
  Plugin 'mileszs/ack.vim'
  Plugin 'SirVer/ultisnips'
  Plugin 'sjl/gundo.vim'
  Plugin 'tomasr/molokai'
  if has("unix")
    let s:uname = system("uname")
    if s:uname !~ "CYGWIN.*"
      Plugin 'Valloric/YouCompleteMe'
    endif
  endif

  Plugin 'tpope/vim-fugitive'
  Plugin 'tpope/vim-surround'
  Plugin 'vim-scripts/sessionman.vim'
  Plugin 'vim-scripts/ZoomWin'

  Plugin 'wincent/Command-T'
  let g:CommandTMaxFiles=30000
  let g:CommandTMaxCachedDirectories=10
"-----

"----- Load neocomplete
  Plugin 'Shougo/neocomplete'
  let g:neocomplete#enable_at_startup = 1
"-----

"----- Syntax checkers
  Plugin 'klen/python-mode'
"-----

"----- Snippets
  Plugin 'MarcWeber/vim-addon-mw-utils'
  Plugin 'tomtom/tlib_vim'
  Plugin 'garbas/vim-snipmate'
  Plugin 'honza/vim-snippets'
"-----

"----- Color schemes
  Plugin 'flazz/vim-colorschemes'
"-----

"----- NERDTree
  Plugin 'scrooloose/nerdtree'
  Plugin 'scrooloose/nerdcommenter'

  " open NERDTree if no files were opened
  autocmd vimenter * NERDTree

  " close vim if NERDTree is the only window open
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"-----

"----- Vundle config end
  call vundle#end()
  filetype plugin indent on
"-----

"----- Activate color scheme and highlighting options
  syntax enable
  syntax on
  colorscheme Tomorrow-Night-Bright
"-----

"----- Custom Key Mappings
  " for split windows and 'frames'
  nnoremap <leader>sfj :botright new<CR>
  nnoremap <leader>sfk :topleft new<CR>
  nnoremap <leader>sfh :topleft vnew<CR>
  nnoremap <leader>sfl :botright vnew<CR>
  nnoremap <leader>sj  :rightbelow new<CR>
  map <C-_> <leader>sj 
  nnoremap <leader>sk  :leftabove new<CR>
  nnoremap <leader>sh  :leftabove vnew<CR>
  nnoremap <leader>sl  :rightbelow vnew<CR>
  map <C-\> <leader>sl

  nnoremap <leader>nhl :nohlsearch<CR>
  nnoremap <leader>tn  :tabnew<CR>
  nnoremap <leader>k   :bdelete<CR>

  nnoremap <leader>nt  :NERDTreeFocus<CR>
  nnoremap <leader>ntt :NERDTreeToggle<CR>

  nnoremap <leader>tbt :TagbarToggle<CR>
  
  nnoremap <leader>bb  :buffers<CR>

  nnoremap <leader>a   :Ack 

  nnoremap <leader>wp  :set wrap<CR>
  nnoremap <leader>nwp :set nowrap<CR>
  
  map <leader>= <C-w>=<CR>
  map <leader>w <C-w><C-w><CR>

  " for switching tab left and right
  nnoremap <leader>tl :tabnext<CR>
  nnoremap <leader>th :tabprev<CR>
  nnoremap <leader>tm :tabmove 
  " TODO : figure out how to go to any tab
  "nnoremap <leader>tg {i}gt<CR>
  nnoremap <leader>tq :tabclose<CR>
  nnoremap <leader>t1 1gt<CR>
  nnoremap <leader>t2 2gt<CR>
  nnoremap <leader>t3 3gt<CR>
  nnoremap <leader>t4 4gt<CR>

  " ctrl-movement keys for window switching
  map <C-k> <C-w><Up>
  map <C-j> <C-w><Down>
  map <C-l> <C-w><Right>
  map <C-h> <C-w><Left>

  " ctrl-arrow keys for window resizing
  nnoremap <C-Right> :vertical resize +1<CR>
  nnoremap <C-Left>  :vertical resize -1<CR>
  nnoremap <C-Up>    :resize -1<CR>
  nnoremap <C-Down>  :resize +1<CR>

  " shorcut for shift-:
  nnoremap ; :
"-----

if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    let $PYTHONHOME='/System/Library/Frameworks/Python.framework/Versions/Current'
  endif
endif
