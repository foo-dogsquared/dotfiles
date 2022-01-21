vim.g['mapleader'] = " "
vim.g['syntax'] = true

-- Bootstrapping for the package manager
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]
-- Plugins
require("packer").startup(function(use)
  if packer_bootstrap then
    require("packer").sync()
  end

  -- Let the package manager manage itself.
  use { "wbthomason/packer.nvim", opt = true }

  -- Custom color themes!
  use { "rktjmp/lush.nvim" }

  -- EditorConfig plugin
  use { "editorconfig/editorconfig-vim" }

  -- Colorize common color strings
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  }

  -- A snippets engine.
  -- One of the must-haves for me.
  use {
    "sirver/ultisnips",
    config = function()
      vim.g.UltiSnipsEditSplit = "context"
      vim.g.UltiSnipsSnippetDirectories = {vim.env.HOME .. "/.config/nvim/own-snippets", ".snippets"}
    end,

    -- Contains various snippets for UltiSnips.
    requires = "honza/vim-snippets"
  }

  -- Fuzzy finder of lists
  use {
    "nvim-telescope/telescope.nvim",
    config = function()
        vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
        vim.api.nvim_set_keymap('n', '<leader>fF', '<cmd>Telescope file_browser<cr>', { noremap = true })
        vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope grep_string<cr>', { noremap = true })
        vim.api.nvim_set_keymap('n', '<leader>fG', '<cmd>Telescope live_grep<cr>', { noremap = true })
        vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
        vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
    end,
    requires = { {"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"} }
  }

  -- Marks in ~~steroids~~ coconut oil
  use {
      "ThePrimeagen/harpoon",
      config = function()
        vim.api.nvim_set_keymap("n", "<leader>fm", "<cmd>lua require('harpoon.mark').add_file()<cr>", {})
        vim.api.nvim_set_keymap("n", "<leader>fM", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", {})
      end,
      requires = { {"nvim-lua/plenary.nvim"} }
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

      local has_any_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end

        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local press = function(key)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
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
            if cmp.visible() then
              if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                return press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
              end

              cmp.select_next_item()
            elseif has_any_words_before() then
              press("<Space>")
            else
              fallback()
            end
          end, {
          "i",
          "s",
        }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.get_selected_entry() == nil and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
            press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
          elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            press("<ESC>:call UltiSnips#JumpForwards()<CR>")
          elseif cmp.visible() then
            cmp.select_next_item()
          elseif has_any_words_before() then
            press("<Tab>")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
          press("<C-R>=UltiSnips#JumpBackwards()<CR>")
        elseif cmp.visible() then
          cmp.select_previous_item()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    }})
  end
  }

  -- A linting engine, a DAP client, and an LSP client entered into a bar.
  use { "dense-analysis/ale" }
  use { "neovim/nvim-lspconfig" }
  use { "mfussenegger/nvim-dap" }
  use { "puremourning/vimspector" }

  -- tree-sitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },

          indent = { enable = true },
        })
      end
  }

  -- One of the most popular plugins.
  -- Allows to create more substantial status bars.
  use { "vim-airline/vim-airline" }

  -- Fuzzy finder for finding files freely and fastly.
  use {
    "junegunn/fzf",
    requires = "junegunn/fzf.vim"
  }

  -- Enable visuals for addition/deletion of lines in the gutter (side) similar to Visual Studio Code.
  use { "airblade/vim-gitgutter" }

  -- Language plugins.
  use { "LnL7/vim-nix" }
  use { "vmchale/dhall-vim" }
end)

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
vim.cmd "highlight CursorLineNr ctermfg=cyan"
vim.cmd "highlight Visual term=reverse cterm=reverse"
vim.cmd "colorscheme fds-theme"

-- Keybindings
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', {})
vim.api.nvim_set_keymap('n', '<leader>hr', '<cmd>source $MYVIMRC<cr>', {})
vim.api.nvim_set_keymap('i', "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap('s', "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap('i', "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap('s', "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })

-- Activating my own modules ala-Doom Emacs.
require('lsp-user-config').setup()
