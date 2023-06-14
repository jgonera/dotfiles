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
  { "marko-cerovac/material.nvim", priority = 1000 },
  { "navarasu/onedark.nvim", priority = 1000 },
  -- Common Lua functions
  "nvim-lua/plenary.nvim",
  -- Syntax highlighting
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  -- Fuzzy opener
  "junegunn/fzf",
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
  'numToStr/Comment.nvim',
  -- LSP and Autocompletion
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "L3MON4D3/LuaSnip",
  'saadparwaiz1/cmp_luasnip',
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  "williamboman/mason-lspconfig.nvim",
  -- Autoformatting and linting
  "jose-elias-alvarez/null-ls.nvim",
  "dense-analysis/ale",
  -- Easier marks
  "kshenoy/vim-signature",
})

vim.g.material_style = "darker"

require('material').setup({
  disable = {
    background = true
  },
  high_visibility = {
    darker = true -- Enable higher contrast text for darker style
  },
})

require('onedark').setup({
  style = 'warm',
  transparent = true,
  code_style = {
    comments = 'none',
  },
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

require("mason").setup()
require("mason-lspconfig").setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason-lspconfig").setup_handlers {
  function (server_name)
    require("lspconfig")[server_name].setup {
      capabilities = capabilities
    }
  end,
}

require("Comment").setup()

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.completion.spell,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.diagnostics.flake8,
  },
})

-- Treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- nvim-cmp
local cmp = require'cmp'
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

vim.cmd([[
" Color scheme
colorscheme onedark
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

" ALE (autoformatting)
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
let g:ale_linters = {}
let g:ale_linters_explicit = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_prettier_options = '--prose-wrap always'
let g:ale_fix_on_save = 1
command! ALEDisableFixers let g:ale_fix_on_save=0
command! ALEEnableFixers let g:ale_fix_on_save=1

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

" Use ripgrep if possible.
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
endif
]])
