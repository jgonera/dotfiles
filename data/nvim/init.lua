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
  { "navarasu/onedark.nvim", priority = 1000 },
  -- Common Lua functions
  "nvim-lua/plenary.nvim",
  -- Syntax highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- Fuzzy opener
  "ibhagwan/fzf-lua",
  -- Automatic indentation
  "tpope/vim-sleuth",
  -- Better status line
  "nvim-lualine/lualine.nvim",
  -- Git integration (:Git blame, :GBrowse, git signs)
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "lewis6991/gitsigns.nvim",
  -- Easy commenting
  "numToStr/Comment.nvim",
  -- LSP and Autocompletion
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  "williamboman/mason-lspconfig.nvim",
  -- Code navigation
  "stevearc/aerial.nvim",
  -- Autoformatting and linting
  "jose-elias-alvarez/null-ls.nvim",
  "lukas-reineke/lsp-format.nvim",
  -- Easier marks
  "chentoast/marks.nvim",
  -- File management
  "stevearc/oil.nvim",
  -- Key cheatsheet
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },
})

require("onedark").setup({
  style = "warm",
  transparent = true,
  code_style = {
    comments = "none",
  },
  diagnostics = {
    background = false,
  },
})

vim.cmd.colorscheme("onedark")
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
-- Don't fold by default
vim.opt.foldenable = false
-- Prevent cluttering up working directory with ~ and .swp files
vim.opt.backup = false
vim.opt.swapfile = false
-- Change the leader key from \ to ,
vim.g.mapleader = ","
-- Alias ; for : (faster to type)
vim.keymap.set({ "n", "v" }, ";", ":")
-- Don't wrap text by default. Leader+w to toggle
vim.opt.wrap = false
vim.keymap.set("n", "<leader>w", "<cmd>set nowrap!<cr>")
-- When wrapping, break at a word boundary
vim.opt.linebreak = true
-- Close buffer (without removing split)
vim.keymap.set("n", "<leader>d", "<cmd>b#<bar>bd#<cr>")
-- Folding
vim.opt.foldmethod = "indent"
-- Ignore case when searching (and, unfortunately, replacing?)
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Clear search highlight after ESC in Normal mode
vim.keymap.set("n", "<Esc>", "<cmd>noh<cr>")
-- Easier navigation between splits
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

-- Show diagnostics only after save
vim.api.nvim_create_autocmd({ "BufNew", "InsertEnter" }, {
  callback = function(args)
    vim.diagnostic.disable(args.buf)
  end,
})

vim.api.nvim_create_autocmd({ "BufWrite" }, {
  callback = function(args)
    vim.diagnostic.enable(args.buf)
  end,
})

-- Nicer icons for diagnostics
local signs = {
  Error = "󰅚",
  Hint = "󰌶",
  Info = "󰋽",
  Warn = "󰀪",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Diagnostics and LSP shortcuts
vim.keymap.set("n", "<Enter>", vim.diagnostic.open_float)
vim.keymap.set("n", "gj", vim.diagnostic.goto_next)
vim.keymap.set("n", "gk", vim.diagnostic.goto_prev)

vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<Enter>", function()
      local current_lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

      if #vim.diagnostic.get(0, { lnum = current_lnum }) > 0 then
        vim.diagnostic.open_float()
      else
        vim.lsp.buf.hover()
      end
    end, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})

-- Use system clipboard + shortcut for relative path of current file into
-- clipboard
if vim.fn.has("macunix") then
  vim.opt.clipboard = "unnamed"
  vim.keymap.set("n", "<leader>rp", '<cmd>let @*=expand("%")<cr>')
elseif vim.fn.has("unix") then
  vim.opt.clipboard = "unnamedplus"
  vim.keymap.set("n", "<leader>rp", '<cmd>let @+=expand("%")<cr>')
end

-- Use ripgrep if possible
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading"
end

-- Show extra whitespace at the end when not in Insert mode
vim.opt.listchars = "trail:—"
vim.cmd("match ErrorMsg /\\s\\+$/")

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = function()
    vim.opt.list = false
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    vim.opt.list = true
  end,
})

-- Highlight current line in active buffer
vim.opt.cursorlineopt = "number"
vim.api.nvim_set_hl(0, "CursorLineNr", { link = "WarningMsg" })

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Plugins
require("mason").setup()
require("mason-lspconfig").setup()
require("lsp-format").setup()
require("marks").setup()
require("gitsigns").setup({
  attach_to_untracked = false,
  signs = {
    untracked = { text = "·" },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "<leader>hr", gs.reset_hunk)
    map("v", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    map("n", "<leader>hR", gs.reset_buffer)
    map("n", "<leader>hp", gs.preview_hunk)
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end)
    map("n", "<leader>hd", gs.diffthis)
    map("n", "<leader>hD", function()
      gs.diffthis("~")
    end)
  end,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
    })
  end,
})

require("lspconfig").eslint.setup({
  capabilities = capabilities,
  on_attach = function(_client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

require("Comment").setup()

local null_ls = require("null-ls")
null_ls.setup({
  on_attach = require("lsp-format").on_attach,
  sources = {
    null_ls.builtins.diagnostics.actionlint,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.selene,
    null_ls.builtins.diagnostics.stylelint,
    null_ls.builtins.diagnostics.terraform_validate,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.prettier.with({
      extra_filetypes = { "sql" },
    }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.terraform_fmt,
  },
})

-- Treesitter
require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "lua", "vim", "vimdoc", "query" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

-- nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  completion = {
    autocomplete = false,
  },
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
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- fzf-lua
local fzf_lua = require("fzf-lua")

fzf_lua.setup({
  winopts = {
    fullscreen = true,
    preview = {
      flip_columns = 180,
      horizontal = "right:50%",
      title = false,
      vertical = "down:50%",
    },
  },
  diagnostics = {
    path_shorten = true,
  },
})

vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "WinSeparator" })
vim.keymap.set("n", "<leader>e", fzf_lua.files)
vim.keymap.set("n", "<leader>f", fzf_lua.lgrep_curbuf)
vim.keymap.set("n", "<leader>g", fzf_lua.live_grep_native)
vim.keymap.set("v", "<leader>g", fzf_lua.grep_visual)
vim.keymap.set("n", "<leader>*", fzf_lua.grep_cword)
vim.keymap.set("n", "<leader>m", fzf_lua.marks)
vim.keymap.set("n", "<leader>a", fzf_lua.lsp_code_actions)

vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
  callback = function(args)
    if args.file == ":" then
      vim.keymap.set("c", "<C-k>", function()
        fzf_lua.command_history({ fzf_opts = { ["--layout"] = "default" } })
      end)
    elseif args.file == "/" or args.file == "?" then
      vim.keymap.set("c", "<C-k>", function()
        -- Close command line mode first, otherwise it conflicts with
        -- fzf_lua.search_history
        vim.api.nvim_feedkeys("<Esc>", "t", true)
        fzf_lua.search_history({
          reverse_search = args.file == "?",
          fzf_opts = { ["--layout"] = "default" },
        })
      end)
    end
  end,
})

vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
  callback = function()
    vim.keymap.del("c", "<C-k>")
  end,
})

-- aerial
require("aerial").setup({
  attach_mode = "global",
  close_on_select = true,
  layout = {
    default_direction = "right",
    placement = "edge",
  },
  nerd_font = true,
  on_attach = function(bufnr)
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

local fzf_aerial = function()
  local labels = require("aerial.fzf").get_labels()

  if #labels > 0 then
    fzf_lua.fzf_exec(labels, {
      actions = {
        ["default"] = function(a)
          print(a[1])
          require("aerial.fzf").goto_symbol(a[1])
        end,
      },
    })
  end
end

-- vim.keymap.set("n", "<leader>c", fzf_aerial)
vim.keymap.set("n", "<leader>c", "<cmd>AerialToggle<CR>")

-- lualine
require("lualine").setup({
  options = {
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diagnostics" },
    lualine_c = { { "filename", path = 1, separator = "⟩" }, "aerial" },
    lualine_x = { "encoding" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- oil
require("oil").setup({
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["g."] = "actions.toggle_hidden",
  },
})

vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
