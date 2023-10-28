return {
  -- Enable visuals for addition/deletion of lines in the gutter (side) similar
  -- to Visual Studio Code.
  "airblade/vim-gitgutter",

  -- Base16 support
  "RRethy/nvim-base16",

  -- Make your Neovim pretty
  {
    "rktjmp/lush.nvim",
    priority = 1000,
    module = true,
    config = function()
      vim.cmd("colorscheme fds-theme")
    end,
  },

  -- More useful status bar
  "vim-airline/vim-airline",

  -- Colorize common color strings
  {
    "norcalli/nvim-colorizer.lua",
    config = true,
  }
}
