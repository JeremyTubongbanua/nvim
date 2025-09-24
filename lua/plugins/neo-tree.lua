return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({
          action = "focus",
          source = "filesystem",
          position = "left",
          dir = vim.loop.cwd(),
        })
      end,
      desc = "Explorer",
    },
  },
  opts = {
    popup_border_style = "rounded",
    sources = { "filesystem", "buffers", "git_status" },
    close_if_last_window = false,
    window = {
      position = "left",
      width = 32,
      mappings = {
        ["C"] = "set_root", -- descend into node
        ["X"] = "navigate_up", -- ascend to parent
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = ">",
        expander_expanded = "v",
      },
    },
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
      window = {
        mappings = {
          ["."] = "set_root",
          ["<BS>"] = "navigate_up",
        },
      },
    },
  },
}
