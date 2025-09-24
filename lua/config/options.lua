-- Ensure the ShaDa file lives in a writable location inside the config tree
local shada_dir = vim.fn.stdpath("config") .. "/shada"
vim.fn.mkdir(shada_dir, "p")
vim.opt.shadafile = shada_dir .. "/main.shada"

local options = {
  number = true,
  relativenumber = true,
  showtabline = 2, -- keep bufferline visible like VSCode tabs
  expandtab = true,
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  -- list = true,
  -- listchars = {
  --   tab = "> ",
  --   trail = ".",
  --   extends = ">",
  --   precedes = "<",
  -- },
  -- foldmethod = "expr",
  -- foldexpr = "nvim_treesitter#foldexpr()",
  -- foldlevel = 99,
  -- foldlevelstart = 99,
  -- foldenable = true,
  -- foldcolumn = "0",
  -- Mirror absolute and relative numbers in the gutter.
  -- statuscolumn = "%s%=%{v:lnum} %{v:relnum == 0 and '' or v:relnum}",
}

for name, value in pairs(options) do
  vim.opt[name] = value
end
