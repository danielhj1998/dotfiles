return {
  "folke/noice.nvim",
  opts = {
    presets = {
      command_palette = true, -- This centers both the cmdline and popupmenu by default
    },
    views = {
      cmdline_popup = {
        position = {
          row = "50%", -- Centered vertically
          col = "50%", -- Centered horizontally
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
      cmdline_popupmenu = {
        position = {
          row = "67%", -- Menu appears below the centered cmdline
          col = "50%",
        },
      },
    },
  },
}
