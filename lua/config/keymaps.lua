local map = vim.keymap.set
local terminal = require("config.terminal")

local function in_bottom_terminal(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return vim.bo[buf].buftype == "terminal" and vim.b[buf].bottom_terminal == true
end

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

local function apply_mappings(mappings)
  for _, mapping in ipairs(mappings) do
    local opts = vim.tbl_extend("force", { silent = true }, mapping.opts or {})
    map(mapping.modes or "n", mapping.lhs, mapping.rhs, opts)
  end
end

apply_mappings({
  { modes = "n", lhs = "<Tab>", rhs = ":bnext<CR>", opts = { desc = "Next buffer" } },
  { modes = "n", lhs = "<S-Tab>", rhs = ":bprev<CR>", opts = { desc = "Previous buffer" } },
  {
    modes = "n",
    lhs = "<leader>x",
    rhs = function()
      require("bufdel").bufdel()
    end,
    opts = { desc = "Delete buffer" },
  },
  { modes = "n", lhs = "<leader>X", rhs = close_main_buffers, opts = { desc = "Close main buffers" } },
  { modes = "n", lhs = "gg", rhs = "gg0", opts = { desc = "Jump to top of file" } },
  { modes = {"n", "v"}, lhs = "G", rhs = "G$", opts = { desc = "Jump to end of file" } },
  { modes = {"n", "v"}, lhs = "E", rhs = "$", opts = { desc = "Go to end of the line" }},
  { modes = {"n", "v"}, lhs = "B", rhs = "^", opts = { desc = "Go to first word" }},
})

apply_mappings({
  { modes = "n", lhs = "<leader>t1", rhs = terminal.open_primary, opts = { desc = "Focus bottom terminal" } },
  { modes = "n", lhs = "<leader>t2", rhs = terminal.open_secondary, opts = { desc = "Bottom terminal split" } },
  { modes = { "n", "t" }, lhs = "<C-\\>", rhs = terminal.toggle_panel, opts = { desc = "Toggle bottom terminals" } },
  { modes = "t", lhs = "<C-w>h", rhs = [[<C-\><C-n><C-w>h]], opts = { desc = "Terminal left window" } },
  { modes = "t", lhs = "<C-w>j", rhs = [[<C-\><C-n><C-w>j]], opts = { desc = "Terminal lower window" } },
  { modes = "t", lhs = "<C-w>l", rhs = [[<C-\><C-n><C-w>l]], opts = { desc = "Terminal right window" } },
})

apply_mappings({
  {
    modes = "n",
    lhs = "<C-w>k",
    rhs = function()
      if in_bottom_terminal() then
        focus_main_window()
      else
        vim.cmd("wincmd k")
      end
    end,
    opts = { desc = "Window up" },
  },
  {
    modes = "t",
    lhs = "<C-w>k",
    rhs = function()
      local buf = vim.api.nvim_get_current_buf()
      if in_bottom_terminal(buf) then
        local esc = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
        vim.api.nvim_feedkeys(esc, "n", false)
        vim.schedule(focus_main_window)
      else
        local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>k", true, false, true)
        vim.api.nvim_feedkeys(keys, "n", false)
      end
    end,
    opts = { desc = "Terminal main window" },
  },
})

vim.api.nvim_create_user_command("Q", "qall", {})
