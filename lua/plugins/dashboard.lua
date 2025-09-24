-- lua/plugins/dashboard.lua
return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {
    theme = "hyper",
    config = {
      week_header = { enable = true },
      shortcut = {
        { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
        {
          icon = " ",
          icon_hl = "@variable",
          desc = "Files",
          group = "Label",
          action = function() require("telescope.builtin").find_files() end,
          key = "f",
        },
        {
          desc = " Buffers",
          group = "DiagnosticHint",
          action = function() require("telescope.builtin").buffers() end,
          key = "a",
        },
        {
          desc = " Grep",
          group = "Number",
          action = function() require("telescope.builtin").live_grep() end,
          key = "d",
        },
      },
    },
  },
}

