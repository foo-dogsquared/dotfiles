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
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local nvim_lsp = require("lspconfig")

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        local function buf_set_option(...)
          vim.api.nvim_buf_set_option(bufnr, ...)
        end

        -- Enable completion triggered by <c-x><c-o>
        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Mappings.
        local opts = { noremap = true, silent = true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", print(vim.inspect(vim.lsp.buf.list_workspace_folders, opts)))
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<space>e", vim.lsp.diagnostic.show_line_diagnostics, opts)
        vim.keymap.set("n", "[d", vim.lsp.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.lsp.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<space>q", vim.lsp.diagnostic.set_loclist, opts)
        vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, opts)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Enable the following language servers
      local servers = {
        "clangd",
        "rust_analyzer",
        "pyright",
        "tsserver",
        "nil_ls",
        "lua_ls",
      }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
    end,
  },
}
