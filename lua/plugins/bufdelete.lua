return {
  "ojroques/nvim-bufdel",
  opts = {
    next = "alternate",
    quit = false,
  },
  config = function(_, opts)
    require("bufdel").setup(opts)
  end,
}
