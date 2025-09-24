local servers = {
  clangd = {},
  pyright = {},
  dartls = {
    flags = {
      allow_incremental_sync = false,
    },
    settings = {
      dart = {
        renameFilesWithClasses = true,
        updateImportsOnRename = true,
      },
    },
  },
}

local function mason_supported_servers()
  local ok, mappings = pcall(require, "mason-lspconfig.mappings.server")
  if not ok then
    return vim.tbl_keys(servers)
  end

  local ensure = {}
  for server_name in pairs(servers) do
    if mappings.lspconfig_to_package[server_name] then
      table.insert(ensure, server_name)
    else
      vim.notify(
        string.format('Skipping Mason ensure for "%s" (unsupported by mason-lspconfig)', server_name),
        vim.log.levels.WARN
      )
    end
  end

  table.sort(ensure)
  return ensure
end

local function default_on_attach(_, bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "LSP definition")
  map("n", "gr", vim.lsp.buf.references, "LSP references")
  map("n", "K", vim.lsp.buf.hover, "LSP hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
  map("n", "<leader>fd", vim.diagnostic.open_float, "Line diagnostics")
  map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
end

local function setup_servers()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end

  vim.lsp.config("*", {
    on_attach = default_on_attach,
  })

  for server_name, server_opts in pairs(servers) do
    local opts = vim.tbl_deep_extend("force", {
      capabilities = vim.deepcopy(capabilities),
    }, server_opts or {})

    vim.lsp.config(server_name, opts)
    vim.lsp.enable(server_name)
  end
end

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = mason_supported_servers(),
        automatic_enable = false,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = setup_servers,
  },
  {
    "akinsho/flutter-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      require("flutter-tools").setup({
        -- Add feature-specific overrides (flutter_path, dev_log, etc.) if needed.
        lsp = {
          on_attach = default_on_attach,
          capabilities = capabilities,
          flags = {
            allow_incremental_sync = false,
          },
        },
      })
    end,
  },
}
