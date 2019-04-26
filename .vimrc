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
  set noswapfile
  set number
  set relativenumber
  set cursorline
  set wrap
  let mapleader=","
  set hidden
  set autoindent
  set shiftwidth=4
  set showmatch
  set pastetoggle=<F2>
"-----

"----- vim-plug https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
"----- vim-plug end

"----- Vim Bundles
  Plug 'editorconfig/editorconfig-vim'
  Plug 'greyblake/vim-preview'
  Plug 'suan/vim-instant-markdown'
  Plug 'jlanzarotta/bufexplorer'

  "----- vim-airline
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme='soda'
  "-----

  Plug 'vim-scripts/vim-auto-save'
  let g:auto_save = 1  " enable AutoSave on Vim startup
  let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option
  let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

  "----- golang
  Plug 'nsf/gocode', {'rtp': 'vim/'}
  "-----

  "----- fuzzy finder
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  "-----

  Plug 'ghewgill/vim-scmdiff'
  Plug 'Lokaltog/vim-powerline'
  Plug 'Lokaltog/vim-easymotion'
  Plug 'majutsushi/tagbar'
  Plug 'mileszs/ack.vim'
  Plug 'SirVer/ultisnips'
  Plug 'sjl/gundo.vim'
  Plug 'tomasr/molokai'
  Plug 'Valloric/YouCompleteMe'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'vim-scripts/sessionman.vim'
  Plug 'vim-scripts/ZoomWin'
"-----

"----- Load neocomplete
  Plug 'Shougo/neocomplete'
  let g:neocomplete#enable_at_startup = 1
"-----

"----- Syntax checkers
  Plug 'python-mode/python-mode'
  let g:pymode_lint = 1
  let g:pymode_folding = 0
  let g:pymode_rope = 0

  "----- Scrooloose
  Plug 'scrooloose/syntastic'
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  "-----
"-----

"----- Snippets
  Plug 'MarcWeber/vim-addon-mw-utils'
  Plug 'tomtom/tlib_vim'
  Plug 'garbas/vim-snipmate'
  Plug 'honza/vim-snippets'
"-----

"----- Color schemes
  Plug 'flazz/vim-colorschemes'
"-----

"----- NERDTree
  Plug 'scrooloose/nerdtree'
  Plug 'scrooloose/nerdcommenter'

  " open NERDTree at startup
  autocmd vimenter * NERDTree
  " switch focus back to open file or buffer, not NERDTree
  autocmd vimenter * wincmd p
  " close vim if NERDTree is the only window open
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"-----

"----- vim-plug
call plug#end()
"-----

"----- autoread watcher from http://vim.wikia.com/wiki/Have_Vim_check_automatically_if_the_file_has_changed_externally
function! WatchForChanges(bufname, ...)
  " Figure out which options are in effect
  if a:bufname == '*'
    let id = 'WatchForChanges'.'AnyBuffer'
    " If you try to do checktime *, you'll get E93: More than one match for * is given
    let bufspec = ''
  else
    if bufnr(a:bufname) == -1
      echoerr "Buffer " . a:bufname . " doesn't exist"
      return
    end
    let id = 'WatchForChanges'.bufnr(a:bufname)
    let bufspec = a:bufname
  end
  if len(a:000) == 0
    let options = {}
  else
    if type(a:1) == type({})
      let options = a:1
    else
      echoerr "Argument must be a Dict"
    end
  end
  let autoread    = has_key(options, 'autoread')    ? options['autoread']    : 0
  let toggle      = has_key(options, 'toggle')      ? options['toggle']      : 0
  let disable     = has_key(options, 'disable')     ? options['disable']     : 0
  let more_events = has_key(options, 'more_events') ? options['more_events'] : 1
  let while_in_this_buffer_only = has_key(options, 'while_in_this_buffer_only') ? options['while_in_this_buffer_only'] : 0
  if while_in_this_buffer_only
    let event_bufspec = a:bufname
  else
    let event_bufspec = '*'
  end
  let reg_saved = @"
  "let autoread_saved = &autoread
  let msg = "\n"
  " Check to see if the autocommand already exists
  redir @"
    silent! exec 'au '.id
  redir END
  let l:defined = (@" !~ 'E216: No such group or event:')
  " If not yet defined...
  if !l:defined
    if l:autoread
      let msg = msg . 'Autoread enabled - '
      if a:bufname == '*'
        set autoread
      else
        setlocal autoread
      end
    end
    silent! exec 'augroup '.id
      if a:bufname != '*'
        "exec "au BufDelete    ".a:bufname . " :silent! au! ".id . " | silent! augroup! ".id
        "exec "au BufDelete    ".a:bufname . " :echomsg 'Removing autocommands for ".id."' | au! ".id . " | augroup! ".id
        exec "au BufDelete    ".a:bufname . " execute 'au! ".id."' | execute 'augroup! ".id."'"
      end
        exec "au BufEnter     ".event_bufspec . " :checktime ".bufspec
        exec "au CursorHold   ".event_bufspec . " :checktime ".bufspec
        exec "au CursorHoldI  ".event_bufspec . " :checktime ".bufspec
      " The following events might slow things down so we provide a way to disable them...
      " vim docs warn:
      "   Careful: Don't do anything that the user does
      "   not expect or that is slow.
      if more_events
        exec "au CursorMoved  ".event_bufspec . " :checktime ".bufspec
        exec "au CursorMovedI ".event_bufspec . " :checktime ".bufspec
      end
    augroup END
    let msg = msg . 'Now watching ' . bufspec . ' for external updates...'
  end
  " If they want to disable it, or it is defined and they want to toggle it,
  if l:disable || (l:toggle && l:defined)
    if l:autoread
      let msg = msg . 'Autoread disabled - '
      if a:bufname == '*'
        set noautoread
      else
        setlocal noautoread
      end
    end
    " Using an autogroup allows us to remove it easily with the following
    " command. If we do not use an autogroup, we cannot remove this
    " single :checktime command
    " augroup! checkforupdates
    silent! exec 'au! '.id
    silent! exec 'augroup! '.id
    let msg = msg . 'No longer watching ' . bufspec . ' for external updates.'
  elseif l:defined
    let msg = msg . 'Already watching ' . bufspec . ' for external updates'
  end
  " echo msg
  let @"=reg_saved
endfunction

" Save buffers when leaving buffer or vim and autoread when focus returns
let autoreadargs={'autoread':1}
execute WatchForChanges("*",autoreadargs)
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

  nnoremap <leader>ntf :NERDTreeFind<CR>
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
  nnoremap <C-Up>    :resize +1<CR>
  nnoremap <C-Down>  :resize -1<CR>

  " shorcut for shift-:
  nnoremap ; :
"-----
