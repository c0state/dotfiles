"----- General
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
  
  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
"-----

"----- Vundle Bundles
  Bundle 'altercation/vim-colors-solarized'
  Bundle 'bufexplorer.zip'
  Bundle 'Color-Sampler-Pack'
  Bundle 'gmarik/vundle'
  Bundle 'greyblake/vim-preview'
  Bundle 'garbas/vim-snipmate'
  Bundle 'vim-scripts/ShowMarks'
  Bundle 'ghewgill/vim-scmdiff'
  Bundle 'kien/ctrlp.vim'
  Bundle 'Lokaltog/vim-powerline'
  Bundle 'Lokaltog/vim-easymotion'
  Bundle 'majutsushi/tagbar'
  Bundle 'MarcWeber/vim-addon-mw-utils'
  Bundle 'matrix.vim--Yang'
  Bundle 'mileszs/ack.vim'

  "----- Python
  Bundle 'klen/python-mode'
  Bundle 'python.vim'
  Bundle 'python_match.vim'
  Bundle 'pythoncomplete'
  "-----

  Bundle 'scrooloose/nerdtree'
  Bundle 'scrooloose/syntastic'
  Bundle 'scrooloose/nerdcommenter'

  Bundle 'Shougo/neocomplcache'
  Bundle 'snipmate-snippets'
  Bundle 'tomtom/tlib_vim'
  Bundle 'tpope/vim-fugitive'
  Bundle 'tpope/vim-surround'
  Bundle 'vim-scripts/sessionman.vim'
  Bundle 'vim-scripts/ZoomWin'

  Bundle 'wincent/Command-T'
  let g:CommandTMaxFiles=30000
  let g:CommandTMaxCachedDirectories=10
"-----

"----- Color Theme
  colorscheme vividchalk
  syntax enable
  syntax on
"-----

"----- NERDTree
  " open NERDTree if no files were opened
  autocmd vimenter * if !argc() | NERDTree | endif

  " close vim if NERDTree is the only window open
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
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

  " for switching windows left and right
  map <leader>< gT
  map <leader>> gt

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

"----- Load neocomplcache
  let g:neocomplcache_enable_at_startup = 1
"-----

