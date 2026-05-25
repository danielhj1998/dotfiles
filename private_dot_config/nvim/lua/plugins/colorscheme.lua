return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  -- add dracula
  { "dracula/vim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
