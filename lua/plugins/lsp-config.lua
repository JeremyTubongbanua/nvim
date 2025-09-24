local servers = {
  clangd = {},
  pyright = {},
  dartls = {
    settings = {
      dart = {
        renameFilesWithClasses = true,
        updateImportsOnRename = true,
      },
    },
  },
}

local function setup_servers()
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end

  local function on_attach(_, bufnr)
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

  local function configure(server_name)
    local opts = vim.tbl_deep_extend("force", {
      capabilities = vim.deepcopy(capabilities),
      on_attach = on_attach,
    }, servers[server_name] or {})

    lspconfig[server_name].setup(opts)
  end

  if type(mason_lspconfig.setup_handlers) == "function" then
    mason_lspconfig.setup_handlers({
      function(server_name)
        configure(server_name)
      end,
    })
  else
    for server_name in pairs(servers) do
      configure(server_name)
    end
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
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
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
      require("flutter-tools").setup({
        -- Configuration options for flutter_tools
        -- e.g., flutter_path, fvm, dev_log, etc.
      })
    end,
  },
}
