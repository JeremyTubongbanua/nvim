return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "UIEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "famiu/bufdelete.nvim", -- safe buffer close, keeps layout (Neo-tree stays)
    },
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer", silent = true },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer", silent = true },
      {
        "<leader>x",
        function() require("bufdelete").bufdelete(0, false) end,
        desc = "Close buffer",
        silent = true,
      },
      { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Pick buffer", silent = true },
    },
    opts = {
      options = {
        mode = "buffers",            -- VSCode-like tabs (buffers)
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = true,
        -- Use bufdelete so closing a tab doesn't kill your sidebar/splits
        close_command = function(n) require("bufdelete").bufdelete(n, false) end,
        middle_mouse_command = function(n) require("bufdelete").bufdelete(n, false) end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
  },
}

