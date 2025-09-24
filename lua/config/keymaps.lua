local terminal = require("config.terminal")

-- Track whether the given buffer (or current one) is the managed bottom terminal.
local function in_bottom_terminal(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return vim.bo[buf].buftype == "terminal" and vim.b[buf].bottom_terminal == true
end

-- Focus the primary editing window above any floating or terminal splits.
local function focus_main_window()
  local best_win
  local best_row = math.huge
  local best_col = math.huge

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative == "" then
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.b[buf].bottom_terminal ~= true and vim.bo[buf].buftype == "" then
          local pos = vim.fn.win_screenpos(win)
          local row, col = pos[1], pos[2]
          if row < best_row or (row == best_row and col < best_col) then
            best_row = row
            best_col = col
            best_win = win
          end
        end
      end
    end
  end

  if best_win and vim.api.nvim_win_is_valid(best_win) then
    vim.api.nvim_set_current_win(best_win)
  else
    vim.cmd("wincmd k")
  end
end

-- Filter to "main" listed file buffers, ignoring terminals and sidebars.
local function is_main_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  if vim.bo[buf].buftype ~= "" then
    return false
  end

  if vim.bo[buf].buflisted == false then
    return false
  end

  if vim.b[buf].bottom_terminal == true then
    return false
  end

  if vim.bo[buf].filetype == "neo-tree" then
    return false
  end

  return true
end

-- Use bufdel to close every main buffer, warning if the plugin is missing.
local function close_main_buffers()
  local ok, bufdel = pcall(require, "bufdel")
  if not ok then
    vim.notify("bufdel plugin not available", vim.log.levels.WARN)
    return
  end

  local targets = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_main_buffer(buf) then
      table.insert(targets, buf)
    end
  end

  for _, buf in ipairs(targets) do
    if vim.api.nvim_buf_is_valid(buf) then
      bufdel.bufdel(buf)
    end
  end
end

-- Core buffer navigation, cleanup, and motion tweaks.
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<leader>x", function()
  require("bufdel").bufdel()
end, { silent = true, desc = "Delete buffer" })
vim.keymap.set("n", "<leader>X", close_main_buffers, { silent = true, desc = "Close main buffers" })
vim.keymap.set("n", "gg", "gg0", { silent = true, desc = "Jump to top of file" })
vim.keymap.set({ "n", "v" }, "G", "G$", { silent = true, desc = "Jump to end of file" })
vim.keymap.set({ "n", "v" }, "E", "$", { silent = true, desc = "Go to end of the line" })
vim.keymap.set({ "n", "v" }, "B", "^", { silent = true, desc = "Go to first word" })

-- Entry points and navigation for the managed bottom terminal splits.
vim.keymap.set("n", "<leader>t1", terminal.open_primary, { silent = true, desc = "Focus bottom terminal" })
vim.keymap.set("n", "<leader>t2", terminal.open_secondary, { silent = true, desc = "Bottom terminal split" })
vim.keymap.set({ "n", "t" }, "<C-\\>", terminal.toggle_panel, { silent = true, desc = "Toggle bottom terminals" })
vim.keymap.set("t", "<C-w>h", [[<C-\><C-n><C-w>h]], { silent = true, desc = "Terminal left window" })
vim.keymap.set("t", "<C-w>j", [[<C-\><C-n><C-w>j]], { silent = true, desc = "Terminal lower window" })
vim.keymap.set("t", "<C-w>l", [[<C-\><C-n><C-w>l]], { silent = true, desc = "Terminal right window" })

-- Let <C-w>k escape the bottom panel and hop back to editing buffers.
vim.keymap.set("n", "<C-w>k", function()
  if in_bottom_terminal() then
    focus_main_window()
  else
    vim.cmd("wincmd k")
  end
end, { silent = true, desc = "Window up" })

vim.keymap.set("t", "<C-w>k", function()
  local buf = vim.api.nvim_get_current_buf()
  if in_bottom_terminal(buf) then
    local esc = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
    vim.api.nvim_feedkeys(esc, "n", false)
    vim.schedule(focus_main_window)
  else
    local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>k", true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
  end
end, { silent = true, desc = "Terminal main window" })

-- Provide :Q as a shorthand to close every window via qall.
vim.api.nvim_create_user_command("Q", "qall", {})
