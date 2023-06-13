local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Color scheme
  "chriskempson/base16-vim",
  -- Fuzzy opener
  "junegunn/fzf.vim",
  -- Automatic indentation
  "tpope/vim-sleuth",
  -- Better status line
  "vim-airline/vim-airline",
  "vim-airline/vim-airline-themes",
  -- Gblame
  "tpope/vim-fugitive",
  -- Gbrowse in GitHub
  "tpope/vim-rhubarb",
  -- Highlight trailing white space
  "ntpeters/vim-better-whitespace",
  -- Easy commenting
  "scrooloose/nerdcommenter",
  -- Autocompletion
  "prabirshrestha/asyncomplete.vim",
  { "prabirshrestha/asyncomplete-buffer.vim", commit = "b8f00ea" },
  -- Easier marks
  "kshenoy/vim-signature",
  -- Linting
  "dense-analysis/ale",
})

-- Enable mouse in terminal
vim.opt.mouse = "a"
-- Don't time out on mappings
vim.opt.timeout = false
-- Do time out on terminal key codes
vim.opt.ttimeout = true
-- Timeout after 50ms
vim.opt.timeoutlen = 50
-- Show line numbers
vim.opt.number = true
-- Keep more space around the cursor when scrolling
vim.opt.scrolloff = 3
-- Indenting and tab settings
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- Always show marks/sign column
vim.opt.signcolumn = "number"
-- Don't fold by default
vim.opt.foldenable = false
-- Prevent cluttering up working directory with ~ and .swp files
vim.opt.backup = false
vim.opt.swapfile = false

vim.cmd([[
" Color scheme.
let base16colorspace=256
source ~/.vimrc_background
" Change the leader key from \ to ,
let mapleader=","
" Alias for :
nnoremap ; :
vnoremap ; :
" Quickly edit/reload the config file.
nmap <silent> <leader>vc :e $MYVIMRC<CR>
nmap <silent> <leader>vl :so $MYVIMRC<CR>
" Syntax synchronization from the beginning of the file (prevents broken
" highlighting after scrolling/jumping).
autocmd BufEnter * :syntax sync fromstart
" Don't wrap text by default. Leader+w to toggle.
set nowrap
" But when wrapping, break at a word boundary
set linebreak
map <silent> <leader>w :set nowrap!<CR>
" Close buffer (without removing split).
nmap <silent> <leader>d :b#<bar>bd#<CR>
" Folding.
set foldmethod=indent
" Ignore case when searching (and, unfortunately, replacing?).
set ignorecase
set smartcase
" Be case sensitive when autocompleting, but not when searching.
au InsertEnter * set noignorecase
au InsertLeave * set ignorecase
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
]])
