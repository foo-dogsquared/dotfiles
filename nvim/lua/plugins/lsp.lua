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
        sources = {
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
        },

        mapping = {
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-l>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
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

  -- Attach it with a debugger.
  "mfussenegger/nvim-dap",

  -- Vimspector Gadget.
  "puremourning/vimspector",

}
