" This supposedly removes compatibility with Vi, but nobody really knows if
" it's needed (http://stackoverflow.com/q/5845557/365238).
set nocompatible

" Plugins.
call plug#begin()

" Color scheme
Plug 'chriskempson/base16-vim'
" Fuzzy opener.
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" Automatic indentation.
Plug 'tpope/vim-sleuth'
" Better status line.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Gblame.
Plug 'tpope/vim-fugitive'
" Gbrowse in GitHub.
Plug 'tpope/vim-rhubarb'
" Highlight trailing white space.
Plug 'ntpeters/vim-better-whitespace'
" Better syntax highlighting for many languages.
Plug 'sheerun/vim-polyglot'
" Easy commenting.
Plug 'scrooloose/nerdcommenter'
" Tree explorer.
Plug 'scrooloose/nerdtree'
" Autocompletion.
Plug 'ervandew/supertab'
" Multi-replace.
Plug 'terryma/vim-multiple-cursors'
" Easier marks.
Plug 'kshenoy/vim-signature'
" Linting.
Plug 'w0rp/ale'

call plug#end()

" Hide buffers with unsaved changes instead of closing them.
set hidden
" Color scheme.
let base16colorspace=256
source ~/.vimrc_background
" Enable mouse in terminal.
set mouse=a
" Don't timeout on mappings.
set notimeout
" Do timeout on terminal key codes.
set ttimeout
" Timeout after 50ms.
set timeoutlen=50
" Change the leader key from \ to ,
let mapleader=","
" Alias for :
nnoremap ; :
vnoremap ; :
" Quickly edit/reload the config file.
nmap <silent> <leader>vc :e $MYVIMRC<CR>
nmap <silent> <leader>vl :so $MYVIMRC<CR>
" Syntax highlighting and indent.
syntax on
" Don't wrap text by default. Leader+w to toggle.
set nowrap
" But when wrapping, break at a word boundary
set linebreak
map <silent> <leader>w :set nowrap!<CR>
" Show line numbers.
set number
" Make backspace work like most other apps.
set backspace=indent,eol,start
" Keep more space around the cursor when scrolling.
set scrolloff=3
" Indenting and tab settings.
filetype plugin indent on
set autoindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
" Automatically insert the current comment leader.
set formatoptions+=or
" Close buffer (without removing split).
nmap <silent> <leader>d :b#<bar>bd#<CR>
" Folding.
set foldmethod=indent
" Don't fold by default.
set nofoldenable
" Ignore case when searching (and, unfortunately, replacing?).
set ignorecase
set smartcase
" Be case sensitive when autocompleting, but not when searching.
au InsertEnter * set noignorecase
au InsertLeave * set ignorecase
" Incremental search.
set incsearch
" Don't highlight search result.
set nohlsearch
" Prevent cluttering up working directory with ~ and .swp files.
set nobackup
set noswapfile
" Always show marks/sign column.
set signcolumn=yes
" Easier navigation between splits.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Format JSON.
command! JsonFormat %!python -m json.tool
" Use system clipboard + shortcut for relative path of current file into
" clipboard.
if has('macunix')
  set clipboard=unnamed
  nmap <leader>rp :let @*=expand("%")<CR>
elseif has('unix')
  set clipboard=unnamedplus
  nmap <leader>rp :let @+=expand("%")<CR>
endif
" Replace selected text with what's in the register without yanking old stuff.
vnoremap <leader>p "0p
vnoremap <leader>P "0P
" Don't use any backups for crontab.
autocmd filetype crontab setlocal nobackup nowritebackup

" airline (statusbar).
set laststatus=2
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_x = ''
let g:airline_section_y = ''

" fzf.
noremap <leader>e <Esc>:Files<CR>
noremap <leader>b <Esc>:Buffers<CR>
nnoremap <leader>f yiw<Esc>:Rg <C-R>0<CR>
vnoremap <leader>f y<Esc>:Rg <C-R>0<CR>
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'],
\}

" NERDTree config.
let NERDTreeMinimalUI = 1
noremap <silent> <leader>t <Esc>:NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Use ripgrep if possible.
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
endif

" ALE (linting).
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'elixir': ['mix_format'],
  \ 'javascript': ['prettier'],
  \ 'typescript': ['prettier'],
\}
let g:ale_linters = {
  \ 'typescript': ['tslint'],
\}
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_typescript_prettier_use_local_config = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'never'
