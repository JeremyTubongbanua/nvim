vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(event)
    if vim.bo[event.buf].filetype == "alpha" then return end

    vim.schedule(function()
      if #vim.fn.getbufinfo({ buflisted = 1 }) > 0 then return end

      local ok, alpha = pcall(require, "alpha")
      if ok then alpha.start(false) end
    end)
  end,
})
