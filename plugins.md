# Plugins

Overview of the specs under `lua/plugins/` and how they interact.

## Editing & Motions
- `windwp/nvim-autopairs` (`lua/plugins/autopairs.lua`) – enables auto-insertion of closing characters on `InsertEnter` with default behaviour.
- `numToStr/Comment.nvim` (`lua/plugins/comment.lua`) – lazy-loads on `VeryLazy` so `gc`/`gb` toggles appear once Neovim finishes starting.
- `mg979/vim-visual-multi` (`lua/plugins/multicursor.lua`) – maps the `\` leader for multi-cursor find-under, regex, and vertical selection workflows.
- `karb94/neoscroll.nvim` (`lua/plugins/smooth_scroll.lua`) – smooth scrolling animation with quadratic easing, keeping the cursor hidden while animating.

## Buffers & Interface
- `akinsho/bufferline.nvim` (`lua/plugins/bufferline.lua`) – VS Code-style buffer tabs with `<Tab>/<S-Tab>` cycling, `<leader>x` delete (using Bufdelete), and a Neo-tree offset.
- `ojroques/nvim-bufdel` (`lua/plugins/bufdelete.lua`) – safe buffer closing that preserves splits; bufferline’s close commands defer to this helper.
- `nvim-lualine/lualine.nvim` (`lua/plugins/lualine.lua`) – Dracula-themed statusline with icon support via Devicons.
- `petertriho/nvim-scrollbar` (`lua/plugins/scrollbar.lua`) – draws a minimal scrollbar after `BufReadPost` to show cursor position and diagnostics.
- `catppuccin/nvim` (`lua/plugins/catpuccin.lua`) – sets the Catppuccin Mocha colourscheme with italic/bold accents.
- `lukas-reineke/indent-blankline.nvim` (`lua/plugins/indent_guides.lua`) – renders ASCII indent guides on buffer load to highlight nesting depth.

## Navigation & Discovery
- `nvimdev/dashboard-nvim` (`lua/plugins/dashboard.lua`) – Hyper dashboard on `VimEnter` with Telescope-powered shortcuts for updates, files, buffers, and live grep.
- `nvim-neo-tree/neo-tree.nvim` (`lua/plugins/neo-tree.lua`) – `<leader>e` toggles a left-positioned tree covering filesystem, buffers, and git status with custom descend/ascend mappings.
- `nvim-telescope/telescope.nvim` (`lua/plugins/telescope.lua`) – fuzzy finder triggered via `:Telescope` or `<leader>f`, backed by Plenary.
- `folke/which-key.nvim` (`lua/plugins/which-key.lua`) – key-hint popups that surface grouped mappings when input pauses.

## Language Servers & Tooling
- `williamboman/mason.nvim` (`lua/plugins/lsp-config.lua`) – GUI installer/back-end for external LSP binaries.
- `williamboman/mason-lspconfig.nvim` (`lua/plugins/lsp-config.lua`) – ensures servers declared in the config are installed when Mason supports them.
- `neovim/nvim-lspconfig` (`lua/plugins/lsp-config.lua`) – shares a default `on_attach`, enables clangd/pyright/dartls clients, and wires common diagnostics & refactor keymaps.
- `akinsho/flutter-tools.nvim` (`lua/plugins/lsp-config.lua`) – Flutter-specific wrapper that reuses the shared LSP capabilities and mappings.

## Treesitter & Syntax
- `nvim-treesitter/nvim-treesitter` (`lua/plugins/treesitter.lua`) – installs parsers via `:TSUpdate`, enabling tree-sitter highlighting and indentation.

## Shared Libraries
- `nvim-lua/plenary.nvim` – Lua utility layer required by Telescope, Neo-tree, and Flutter tools.
- `MunifTanjim/nui.nvim` – UI primitives consumed by Neo-tree.
- `nvim-tree/nvim-web-devicons` (`lua/plugins/nvim-web-devicons.lua`) – Nerd Font icons for Bufferline, Lualine, and Neo-tree.
