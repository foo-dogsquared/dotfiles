-- Aliases
local api = vim.api
local g, b = vim.g, vim.b
local cmd = vim.cmd
local highlight = vim.highlight
local opt, opt_local = vim.opt, vim.opt_local
local go = vim.go
local map = vim.api.nvim_set_keymap
local fn = vim.fn

g['mapleader'] = " "
g['syntax'] = true

-- Bootstrapping for the package manager
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  api.nvim_command('packadd packer.nvim')
end

cmd [[packadd packer.nvim]]
-- Plugins
require("packer").startup(function()
    -- Let the package manager manage itself.
	use { "wbthomason/packer.nvim", opt = true }

    -- THEMES!
	use { "chriskempson/base16-vim" }

    -- EditorConfig plugin
	use { "editorconfig/editorconfig-vim" }
	
    -- Colorize common color strings
	use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require"colorizer".setup()
    end
  }

	-- A snippets engine.
	-- One of the must-haves for me.
	use {
    "sirver/ultisnips",

	  -- Contains various snippets for UltiSnips.
    requires = "honza/vim-snippets"
  }

	-- Text editor integration for the browser
	use {"subnut/nvim-ghost.nvim", run = ":call nvim_ghost#installer#install()"}

  -- Fuzzy finder of lists
  use {
    "nvim-telescope/telescope.nvim", 
    requires = { {"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"} }
  }

	-- A completion engine.
  -- nvim-cmp is mostly explicit by making the configuration process manual unlike bigger plugins like CoC
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "quangnguyen30192/cmp-nvim-ultisnips",
    },
    config = function()
      local cmp = require("cmp")
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local check_back_space = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
        },

        sources = {
          { name = "ultisnips" },
          { name = "buffer" },
          { name = "path" },
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
        },

        mapping = {
          ["<C-Space>"] = cmp.mapping(function(fallback)
            if vim.fn.pumvisible() == 1 then
              if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                return vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<CR>"))
              end

              vim.fn.feedkeys(t("<C-n>"), "n")
            elseif check_back_space() then
              vim.fn.feedkeys(t("<cr>"), "n")
            else
              fallback()
            end
            end, {
            "i",
            "s",
          }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
              vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<CR>"))
            elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
              vim.fn.feedkeys(t("<ESC>:call UltiSnips#JumpForwards()<CR>"))
            elseif vim.fn.pumvisible() == 1 then
              vim.fn.feedkeys(t("<C-n>"), "n")
            elseif check_back_space() then
              vim.fn.feedkeys(t("<tab>"), "n")
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
              return vim.fn.feedkeys(t("<C-R>=UltiSnips#JumpBackwards()<CR>"))
            elseif vim.fn.pumvisible() == 1 then
              vim.fn.feedkeys(t("<C-p>"), "n")
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        }
      })
    end
  }

	-- A linting engine, a DAP client, and an LSP client entered into a bar.
	use { "dense-analysis/ale" }
	use { "neovim/nvim-lspconfig" }
	use { "mfussenegger/nvim-dap" }

	-- One of the most popular plugins.
	-- Allows to create more substantial status bars.
	use { "vim-airline/vim-airline" }

	-- Fuzzy finder for finding files freely and fastly.
	use {
    "junegunn/fzf",
    requires = "junegunn/fzf.vim"
  }

	-- A full LaTeX toolchain plugin for Vim.
	-- Also a must-have for me since writing LaTeX can be a PITA.
	-- Most of the snippets and workflow is inspired from Gilles Castel's posts (at https://castel.dev/).
	use {
        "lervag/vimtex",
        cmd = "ALEEnable",
        config = function()
            -- Vimtex configuration
            g["tex_flavor"] = "latex"
            g["vimtex_view_method"] = "zathura"
            g["vimtex_quickfix_mode"] = 0
            g["tex_conceal"] = "abdmg"
            g["vimtex_compiler_latexmk"] = {
                options = {
                  "-bibtex",
                  "-shell-escape",
                  "-verbose",
                  "-file-line-error",
                }
            }

            -- I use LuaLaTeX for my documents so let me have it as the default, please?
            g["vimtex_compiler_latexmk_engines"] = {
                _                = "-lualatex",
                pdflatex         = "-pdf",
                dvipdfex         = "-pdfdvi",
                lualatex         = "-lualatex",
                xelatex          = "-xelatex",
            }
        end
    }

	-- Enable visuals for addition/deletion of lines in the gutter (side) similar to Visual Studio Code.
	use { "airblade/vim-gitgutter" }

	-- Language plugins.
	use { "LnL7/vim-nix" }
	use { "vmchale/dhall-vim" }
end)

-- g['UltiSnipsExpandTrigger'] = "<c-j>"
g['UltiSnipsEditSplit'] = "context"
g['UltiSnipsSnippetDirectories'] = {vim.env.HOME .. "/.config/nvim/own-snippets", ".snippets"}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Editor configuration
opt.completeopt = "menuone,noselect"
opt.termguicolors = true
opt.encoding = "utf-8"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.conceallevel = 1
opt.list = true
opt.listchars = { tab = "   ", trail = "·" }
opt_local.spell = true
opt.smartindent = true

-- I have yet to solve how to do the following in Lua, lmao
cmd "highlight clear SpellBad"
cmd "highlight clear SpellLocal"
cmd "highlight clear SpellCap"
cmd "highlight clear SpellRare"
cmd "highlight CursorLineNr ctermfg=cyan"
cmd "highlight Visual term=reverse cterm=reverse"

-- Keybindings
map('i', 'jk', '<Esc>', {})
map('n', '<leader>hr', '<cmd>source $MYVIMRC<cr>', {})
map('i', "<Tab>", "v:lua.tab_complete()", { expr = true })
map('s', "<Tab>", "v:lua.tab_complete()", { expr = true })
map('i', "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
map('s', "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
map('n', '<leader>fg', '<cmd>Telescope grep_string<cr>', { noremap = true })
map('n', '<leader>fG', '<cmd>Telescope live_grep<cr>', { noremap = true })
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })

-- LSP config
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
