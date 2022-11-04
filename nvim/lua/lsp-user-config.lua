-- LSP config
local nvim_lsp = require("lspconfig")

function setup()
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function keymap_set(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    keymap_set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap_set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap_set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    keymap_set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    keymap_set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    keymap_set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    keymap_set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    keymap_set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    keymap_set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    keymap_set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    keymap_set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    keymap_set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    keymap_set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    keymap_set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    keymap_set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    keymap_set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    keymap_set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  -- Enable the following language servers
  local servers = { "clangd", "rust_analyzer", "pyright", "tsserver", "rnix", "sumneko_lua" }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
end

return {
  setup = setup,
}
