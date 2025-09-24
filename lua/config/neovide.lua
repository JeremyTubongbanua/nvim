local map = vim.keymap.set

if not vim.g.neovide then
  return
end

-- Keep Neovide looking consistent across sessions and suppress GUI zoom shortcuts.

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local target_scale = vim.g.neovide_scale_factor or 1.0
vim.g.neovide_scale_factor = target_scale

if vim.g.neovide_input_use_logo ~= 1 then
  vim.g.neovide_input_use_logo = 1
end

local zoom_keys = {
  "<D-=>",
  "<D-+>",
  "<D-->",
  "<D-_>",
  "<D-0>",
}

for _, lhs in ipairs(zoom_keys) do
  map({ "n", "v", "i", "t" }, lhs, "<Nop>", { desc = "Disable Neovide zoom", silent = true })
end

map({ "n", "v" }, "<D-c>", '"+y', { desc = "Copy to clipboard", silent = true })
map({ "n", "v" }, "<D-x>", '"+d', { desc = "Cut to clipboard", silent = true })
map("n", "<D-v>", '"+p', { desc = "Paste from clipboard", silent = true })
map("v", "<D-v>", '"+P', { desc = "Paste from clipboard", silent = true })
map("i", "<D-v>", function()
  return termcodes("<C-r>+")
end, { expr = true, desc = "Paste from clipboard", silent = true })
map("c", "<D-v>", termcodes("<C-r>+"), { desc = "Paste from clipboard", silent = true })
map("t", "<D-v>", function()
  return termcodes([[<C-\\><C-n>"+pi]])
end, { expr = true, desc = "Paste from clipboard", silent = true })

map({ "n", "v" }, "<D-s>", "<cmd>w<CR>", { desc = "Save file", silent = true })
map("i", "<D-s>", function()
  vim.schedule(function()
    vim.cmd("silent! write")
  end)
  return ""
end, { expr = true, desc = "Save file", silent = true })

map({ "n", "v" }, "<D-a>", "ggVG", { desc = "Select all", silent = true })
map("i", "<D-a>", function()
  return termcodes("<Esc>ggVG")
end, { expr = true, desc = "Select all", silent = true })

map({ "n", "v" }, "<D-z>", "u", { desc = "Undo", silent = true })
map("i", "<D-z>", function()
  return termcodes("<C-o>u")
end, { expr = true, desc = "Undo", silent = true })

map({ "n", "v" }, "<D-S-z>", "<C-r>", { desc = "Redo", silent = true })
map("i", "<D-S-z>", function()
  return termcodes("<C-o><C-r>")
end, { expr = true, desc = "Redo", silent = true })
