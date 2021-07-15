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
	use {"wbthomason/packer.nvim", opt = true}

    -- THEMES!
	use {"chriskempson/base16-vim"}

    -- EditorConfig plugin
	use {"editorconfig/editorconfig-vim"}
	
    -- Colorize common color strings
	use {'lilydjwg/colorizer'}

	-- A snippets engine.
	-- One of the must-haves for me.
	use { 'sirver/ultisnips' }

	-- Text editor integration for the browser
	use {'subnut/nvim-ghost.nvim', run = ':call nvim_ghost#installer#install()'}

    -- Fuzzy finder of lists
    use {
        'nvim-telescope/telescope.nvim', 
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }

	-- Contains various snippets for UltiSnips.
	use {'honza/vim-snippets'}

	-- A completion engine.
	-- I chose this engine since it is linked from UltiSnips.
    use { "hrsh7th/nvim-compe" }

	-- A linting engine, a DAP client, and an LSP client entered into a bar.
	use {
        'dense-analysis/ale',
        config = function()
            g['ale_disable_lsp'] = 1
            g['ale_linters'] = {
                javascript = {"eslint", "prettier"}
            }
        end
    }
	use {'neovim/nvim-lspconfig'}
	use {'mfussenegger/nvim-dap'}

	-- One of the most popular plugins.
	-- Allows to create more substantial status bars.
	use {
        'vim-airline/vim-airline',
        config = function()
            g['airline_powerline_fonts'] = 1
            g['airline#extensions#ale#enabled'] = 1
        end
    }

	-- Fuzzy finder for finding files freely and fastly.
	use {'junegunn/fzf'}
	use {'junegunn/fzf.vim'}

	-- A full LaTeX toolchain plugin for Vim.
	-- Also a must-have for me since writing LaTeX can be a PITA.
	-- Most of the snippets and workflow is inspired from Gilles Castel's posts (at https://castel.dev/).
	use {
        'lervag/vimtex',
        cmd = 'ALEEnable',
        config = function()
            -- Vimtex configuration
            g['tex_flavor'] = 'latex'
            g['vimtex_view_method'] = 'zathura'
            g['vimtex_quickfix_mode'] = 0
            g['tex_conceal'] = 'abdmg'
            g['vimtex_compiler_latexmk'] = {
                options = {
                  '-bibtex',
                  '-shell-escape',
                  '-verbose',
                  '-file-line-error',
                }
            }

            -- I use LuaLaTeX for my documents so let me have it as the default, please?
            g['vimtex_compiler_latexmk_engines'] = {
                _                = '-lualatex',
                pdflatex         = '-pdf',
                dvipdfex         = '-pdfdvi',
                lualatex         = '-lualatex',
                xelatex          = '-xelatex',
            }
        end
    }

	-- Enable visuals for addition/deletion of lines in the gutter (side) similar to Visual Studio Code.
	use {'airblade/vim-gitgutter'}

	-- Language plugins.
	use {'LnL7/vim-nix'}
	use {'vmchale/dhall-vim'}
end)

g['UltiSnipsExpandTrigger'] = "<c-j>"
g['UltiSnipsEditSplit'] = "context"
g['UltiSnipsSnippetDirectories'] = {vim.env.HOME .. "/.config/nvim/own-snippets", ".snippets"}

-- Compe configuration
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    ultisnips = true;
    luasnip = true;
  };
}

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

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

-- Editor configuration
opt.completeopt = "menuone,noselect"
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
map('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
map('i', '<c-space>', 'compe#complete()', { expr = true })

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

-- Enable the following language servers
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
