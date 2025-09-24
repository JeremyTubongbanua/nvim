return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  opts = {
    hide_cursor = true,
    stop_eof = true,
    easing_function = "quadratic",
  },
  config = function(_, opts)
    require("neoscroll").setup(opts)
  end,
}

