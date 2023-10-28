return {
  -- A completion engine.
  -- nvim-cmp is mostly explicit by making the configuration process manual unlike bigger plugins like CoC
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },

        sources = {
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
        },

        mapping = {
          ["<CR>"] = cmp.mapping.confirm(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-l>"] = cmp.mapping.confirm { select = true },
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-g>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
        },
      })
    end,
  },

  -- A linting engine, a DAP client, and an LSP client entered into a bar.
  {
    "dense-analysis/ale",
    config = function()
      vim.g.ale_disable_lsp = 1
    end,
  },

  -- A bunch of pre-configured LSP configurations.
  "neovim/nvim-lspconfig",



}
