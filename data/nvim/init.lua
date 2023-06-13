vim.cmd([[
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
"Plug 'ervandew/supertab'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim', { 'commit': 'b8f00ea' }
" Easier marks.
Plug 'kshenoy/vim-signature'
" Linting / LSP.
Plug 'dense-analysis/ale'
" .editorconfig support
Plug 'editorconfig/editorconfig-vim'
" CSS3.
Plug 'hail2u/vim-css3-syntax'
" JavaScript import sizes.
Plug 'yardnsm/vim-import-cost', { 'do': 'npm install' }
" JavaScript template tags syntax highlighting.
Plug 'Quramy/vim-js-pretty-template'
" Autoformatting for Markdown, etc.
Plug 'reedes/vim-pencil'

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
" Syntax synchronization from the beginning of the file (prevents broken
" highlighting after scrolling/jumping).
autocmd BufEnter * :syntax sync fromstart
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
command! JSONFormat %!python3 -m json.tool
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
" Highlight current line.
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" airline (statusbar).
set laststatus=2
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline#extensions#ale#enabled = 1

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
let g:ale_linters = {
  \ 'python': ['flake8', 'mypy', 'pylsp'],
  \ 'terraform': ['terraform'],
\}
let g:ale_fixers = {
  \ 'css': ['stylelint', 'prettier'],
  \ 'graphql': ['prettier'],
  \ 'html': ['prettier'],
  \ 'javascript': ['eslint', 'prettier'],
  \ 'json': ['prettier'],
  \ 'markdown': ['prettier'],
  \ 'python': ['black'],
  \ 'sql': ['prettier'],
  \ 'terraform': ['terraform'],
  \ 'typescript': ['eslint', 'prettier'],
  \ 'typescriptreact': ['eslint', 'prettier'],
\}
let g:ale_completion_autoimport = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_prettier_options = '--prose-wrap always'
let g:ale_typescript_prettier_use_local_config = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_sql_pgformatter_options = '--spaces 2'
highlight ALEError ctermbg=18 cterm=none
highlight ALEWarning ctermbg=18 cterm=none
command! ALEDisableFixers let g:ale_fix_on_save=0
command! ALEEnableFixers let g:ale_fix_on_save=1

noremap gj <Esc>:ALENext<CR>
noremap gk <Esc>:ALEPrevious<CR>
noremap gd <Esc>:ALEGoToDefinition<CR>
noremap gt <Esc>:ALEGoToTypeDefinition<CR>
noremap <leader>rn <Esc>:ALERename<CR>

" Asyncomplete.
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ale#get_source_options({
  \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
  \ 'name': 'buffer',
  \ 'whitelist': ['*'],
  \ 'completor': function('asyncomplete#sources#buffer#completor'),
  \ }))

let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S_TAB>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" JavaScript template tags syntax highlighting.
call jspretmpl#register_tag('sql', 'sql')

autocmd FileType javascript JsPreTmpl
autocmd FileType javascript.jsx JsPreTmpl
autocmd FileType typescript JsPreTmpl

let g:pencil#map#suspend_af = 'K'

" csv.vim config.
" Do not replace actual delimiters with `|`.
let g:csv_no_conceal = 1

" CoC.
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
"inoremap <silent><expr> <TAB>
      "\ pumvisible() ? "\<C-n>" :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"function! s:check_back_space() abort
  "let col = col('.') - 1
  "return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
"" Coc only does snippet and additional edit on confirm.
"" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"" Or use `complete_info` if your vim support it, like:
"inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

"" Use `gk` and `gj` to navigate diagnostics
"nmap <silent> gk <Plug>(coc-diagnostic-prev)
"nmap <silent> gj <Plug>(coc-diagnostic-next)

"" Remap keys for gotos
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

"" Use K to show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>

"function! s:show_documentation()
  "if (index(['vim','help'], &filetype) >= 0)
    "execute 'h '.expand('<cword>')
  "else
    "call CocAction('doHover')
  "endif
"endfunction

"" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')

"" Remap for rename current word
"nmap <leader>rn <Plug>(coc-rename)
]])
