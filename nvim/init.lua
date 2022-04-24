-- vim: shiftwidth=2

-- Activating my own modules ala-Doom Emacs.
require("plugins")
require("lsp-user-config").setup()

vim.g['mapleader'] = " "
vim.g['syntax'] = true

-- Editor configuration
vim.opt.completeopt = "menuone,noselect"
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.conceallevel = 1
vim.opt.list = true
vim.opt.listchars = { tab = "   ", trail = "·" }
vim.opt_local.spell = true
vim.opt.smartindent = true

-- I have yet to solve how to do the following in Lua, lmao
vim.cmd "highlight clear SpellBad"
vim.cmd "highlight clear SpellLocal"
vim.cmd "highlight clear SpellCap"
vim.cmd "highlight clear SpellRare"
vim.cmd "highlight Visual term=reverse cterm=reverse"
vim.cmd "colorscheme fds-theme"

-- Keybindings
vim.keymap.set('n', '<leader>bd', ':bd<cr>', {})
vim.keymap.set('i', 'jk', '<Esc>', {})
vim.keymap.set('n', '<leader>hr', '<cmd>source $MYVIMRC<cr>', {})
