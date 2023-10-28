-- Snippets engine. A must have for me.
return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    version = "^2",
    module = true,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load()

      local ls = require("luasnip")
      local types = require("luasnip.util.types")
      ls.config.set_config({
        history = true,
        update_events = "TextChanged,TextChangedI",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "<- Current choice", "Comment" } },
            },
          },
        },
      })

      vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.jumpable(1) then
          ls.jump(1)
        end
      end)

      vim.keymap.set({ "i", "s" }, "<c-k>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end)

      vim.keymap.set({ "i", "s" }, "<c-l>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end)

      vim.keymap.set({ "i", "s" }, "<c-u>", function()
        require("luasnip.extras.select_choice")()
      end)
    end,
  }
}

