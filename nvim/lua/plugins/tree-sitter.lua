-- tree-sitter integration with Neovim.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
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

        highlight_current_scope = { enable = false },
        highlight_definitions = { clear_on_cursor_move = true, enable = true },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "gnd",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
                list_definitions = "gnD",
                list_definitions_toc = "gO",
            },
        },
        smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
        textobjects = {
          lsp_interop = {
            border = "none",
            enable = true,
            peek_definition_code = {
              ["<leader>dF"] = { desc = "Peek definition of class", query = "@class.outer" },
              ["<leader>df"] = { desc = "Peek definition of function", query = "@function.outer" },
            },
          },
          move = {
            enable = true,
            goto_next_end = {
              ["]]b"] = { desc = "Jump to inner part of the next block", query = "@block.inner" },
              ["]]c"] = { desc = "Jump to inner part of the next class", query = "@class.inner" },
              ["]]d"] = { desc = "Jump to inner part of the next conditional", query = "@conditional.inner" },
              ["]]f"] = { desc = "Jump to inner part of the next call", query = "@call.inner" },
              ["]]l"] = { desc = "Jump to inner part of the next loop", query = "@loop.inner" },
              ["]]m"] = { desc = "Jump to inner part of the next function", query = "@function.inner" },
              ["]]s"] = { desc = "Jump to inner part of the next statement", query = "@statement.inner" },
              ["]b"] = { desc = "Jump to next block", query = "@block.outer" },
              ["]c"] = { desc = "Jump to next class", query = "@class.outer" },
              ["]d"] = { desc = "Jump to next conditional", query = "@conditional.outer" },
              ["]f"] = { desc = "Jump to next call", query = "@call.outer" },
              ["]l"] = { desc = "Jump to next loop", query = "@loop.outer" },
              ["]m"] = { desc = "Jump to next function", query = "@function.outer" },
              ["]s"] = { desc = "Jump to next statement", query = "@statement.outer" },
            },
            goto_next_start = {
              ["]]b"] = { desc = "Jump to inner part of the next block", query = "@block.inner" },
              ["]]c"] = { desc = "Jump to inner part of the next class", query = "@class.inner" },
              ["]]d"] = { desc = "Jump to inner part of the next conditional", query = "@conditional.inner" },
              ["]]f"] = { desc = "Jump to inner part of the next call", query = "@call.inner" },
              ["]]l"] = { desc = "Jump to inner part of the next loop", query = "@loop.inner" },
              ["]]m"] = { desc = "Jump to inner part of the next function", query = "@function.inner" },
              ["]]s"] = { desc = "Jump to inner part of the next statement", query = "@statement.inner" },
              ["]b"] = { desc = "Jump to next block", query = "@block.outer" },
              ["]c"] = { desc = "Jump to next class", query = "@class.outer" },
              ["]d"] = { desc = "Jump to next conditional", query = "@conditional.outer" },
              ["]f"] = { desc = "Jump to next call", query = "@call.outer" },
              ["]l"] = { desc = "Jump to next loop", query = "@loop.outer" },
              ["]m"] = { desc = "Jump to next function", query = "@function.outer" },
              ["]s"] = { desc = "Jump to next statement", query = "@statement.outer" },
            },
            goto_previous_end = {
              ["[B"] = { desc = "Jump to previous block", query = "@block.outer" },
              ["[C"] = { desc = "Jump to previous class", query = "@class.outer" },
              ["[D"] = { desc = "Jump to previous conditional", query = "@conditional.outer" },
              ["[F"] = { desc = "Jump to previous call", query = "@call.outer" },
              ["[L"] = { desc = "Jump to previous loop", query = "@loop.outer" },
              ["[M"] = { desc = "Jump to previous function", query = "@function.outer" },
              ["[S"] = { desc = "Jump to previous statement", query = "@statement.outer" },
              ["[[B"] = { desc = "Jump to inner part of the previous block", query = "@block.inner" },
              ["[[C"] = { desc = "Jump to inner part of the previous class", query = "@class.inner" },
              ["[[D"] = { desc = "Jump to inner part of the previous conditional", query = "@conditional.inner" },
              ["[[F"] = { desc = "Jump to inner part of the previous call", query = "@call.inner" },
              ["[[L"] = { desc = "Jump to inner part of the previous loop", query = "@loop.inner" },
              ["[[M"] = { desc = "Jump to inner part of the previous function", query = "@function.inner" },
              ["[[S"] = { desc = "Jump to inner part of the previous statement", query = "@statement.inner" },
            },
            goto_previous_start = {
              ["[B"] = { desc = "Jump to previous block", query = "@block.outer" },
              ["[C"] = { desc = "Jump to previous class", query = "@class.outer" },
              ["[D"] = { desc = "Jump to previous conditional", query = "@conditional.outer" },
              ["[F"] = { desc = "Jump to previous call", query = "@call.outer" },
              ["[L"] = { desc = "Jump to previous loop", query = "@loop.outer" },
              ["[M"] = { desc = "Jump to previous function", query = "@function.outer" },
              ["[S"] = { desc = "Jump to previous statement", query = "@statement.outer" },
              ["[[B"] = { desc = "Jump to inner part of the previous block", query = "@block.inner" },
              ["[[C"] = { desc = "Jump to inner part of the previous class", query = "@class.inner" },
              ["[[D"] = { desc = "Jump to inner part of the previous conditional", query = "@conditional.inner" },
              ["[[F"] = { desc = "Jump to inner part of the previous call", query = "@call.inner" },
              ["[[L"] = { desc = "Jump to inner part of the previous loop", query = "@loop.inner" },
              ["[[M"] = { desc = "Jump to inner part of the previous function", query = "@function.inner" },
              ["[[S"] = { desc = "Jump to inner part of the previous statement", query = "@statement.inner" },
            },
            set_jumps = true,
          },
          select = {
            enable = true,
            keymaps = {
              aa = { desc = "Select around the attribute region", query = "@attribute.outer" },
              ab = { desc = "Select around the block region", query = "@block.outer" },
              ac = { desc = "Select around the class region", query = "@class.outer" },
              af = { desc = "Select around the call region", query = "@call.outer" },
              al = { desc = "Select around the loop region", query = "@loop.outer" },
              am = { desc = "Select around the function region", query = "@function.outer" },
              as = { desc = "Select around the statement region", query = "@statement.outer" },
              ia = { desc = "Select inner part of the attribute region", query = "@attribute.inner" },
              ib = { desc = "Select inner part of the block region", query = "@block.inner" },
              ic = { desc = "Select inner part of the class region", query = "@class.inner" },
              ["if"] = { desc = "Select inner part of the call region", query = "@call.inner" },
              il = { desc = "Select inner part of the loop region", query = "@loop.inner" },
              im = { desc = "Select inner part of the function region", query = "@function.inner" },
              is = { desc = "Select inner part of the statement region", query = "@statement.inner" },
            },
            lookahead = true,
            selection_modes = { ["@block.outer"] = "<c-v>", ["@class.outer"] = "<c-v>", ["@function.outer"] = "V" },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>sa"] = { desc = "Jump to next parameter", query = "@parameter.outer" },
              ["<leader>sd"] = { desc = "Jump to next conditional", query = "@conditional.outer" },
              ["<leader>sf"] = { desc = "Jump to next function", query = "@function.outer" },
            },
            swap_previous = {
              ["<leader>SA"] = { desc = "Jump to previous parameter", query = "@parameter.outer" },
              ["<leader>SD"] = { desc = "Jump to previous conditional", query = "@conditional.outer" },
              ["<leader>SF"] = { desc = "Jump to previous function", query = "@function.outer" },
            },
          },
        },
      })
    end,
  },
}
