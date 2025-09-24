local M = {}

local state = {
  height = 10,
  primary = {},
  secondary = {},
}

local function get_shell()
  if vim.o.shell ~= "" then
    return vim.o.shell
  end
  if vim.env.SHELL and vim.env.SHELL ~= "" then
    return vim.env.SHELL
  end
  return "/bin/sh"
end

local function is_terminal(buf)
  return buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal"
end

local function job_is_running(buf)
  if not is_terminal(buf) then
    return false
  end

  local job = vim.b[buf].terminal_job_id
  if not job then
    return false
  end

  local ok, status = pcall(vim.fn.jobwait, { job }, 0)
  return ok and status[1] == -1
end

local function configure_buffer(buf, slot)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.b[buf].bottom_terminal = true
  vim.b[buf].bottom_terminal_slot = slot
end

local function configure_window(win)
  if not win or not vim.api.nvim_win_is_valid(win) then
    return
  end

  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "cursorline", false)
  vim.api.nvim_win_set_option(win, "signcolumn", "no")
  vim.api.nvim_win_set_option(win, "foldcolumn", "0")
  vim.api.nvim_win_set_option(win, "spell", false)
  vim.api.nvim_win_set_option(win, "winfixheight", true)
  pcall(vim.api.nvim_win_set_height, win, state.height)
end

local function find_window(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
      return win
    end
  end
end

local function ensure_buffer(slot)
  local entry = state[slot]
  local buf = entry.buf
  if not is_terminal(buf) then
    buf = nil
  end

  if not buf then
    buf = vim.api.nvim_create_buf(false, true)
    entry.buf = buf
    vim.api.nvim_buf_set_name(buf, "bottom-terminal://" .. slot)
    vim.api.nvim_buf_call(buf, function()
      vim.fn.termopen(get_shell())
    end)
  elseif not job_is_running(buf) then
    vim.api.nvim_buf_call(buf, function()
      vim.fn.termopen(get_shell())
    end)
  end

  configure_buffer(buf, slot)
  return buf
end

local function ensure_primary_window()
  local buf = ensure_buffer("primary")
  local win = find_window(buf)
  if win and vim.api.nvim_win_is_valid(win) then
    configure_window(win)
    return buf, win
  end

  vim.cmd("botright " .. state.height .. "split")
  win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  configure_window(win)
  return buf, win
end

local function ensure_secondary_window(primary_win)
  local buf = ensure_buffer("secondary")
  local win = find_window(buf)
  if win and vim.api.nvim_win_is_valid(win) then
    configure_window(win)
    return buf, win
  end

  if not primary_win or not vim.api.nvim_win_is_valid(primary_win) then
    return buf, nil
  end

  vim.api.nvim_set_current_win(primary_win)
  vim.cmd("vsplit")
  win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  configure_window(win)
  return buf, win
end

local function bottom_terminal_windows()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].bottom_terminal then
        table.insert(wins, win)
      end
    end
  end
  return wins
end

function M.open_primary()
  local _, win = ensure_primary_window()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    vim.cmd("startinsert")
  end
end

function M.open_secondary()
  local _, primary_win = ensure_primary_window()
  local _, win = ensure_secondary_window(primary_win)
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    vim.cmd("startinsert")
  end
end

function M.toggle_panel()
  local wins = bottom_terminal_windows()
  if #wins > 0 then
    for _, win in ipairs(wins) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end
    pcall(vim.cmd, "wincmd p")
  else
    M.open_primary()
  end
end

vim.api.nvim_create_autocmd("BufDelete", {
  pattern = "bottom-terminal://*",
  callback = function(args)
    if state.primary.buf == args.buf then
      state.primary.buf = nil
    elseif state.secondary.buf == args.buf then
      state.secondary.buf = nil
    end
  end,
})

return M
