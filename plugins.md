# Plugins

Short descriptions of the specs in `lua/plugins/` and how they fit together.

## Editing & Selections
- `windwp/nvim-autopairs` (`lua/plugins/autopairs.lua`) - closes pairs when `InsertEnter` fires; no extra config needed.
- `numToStr/Comment.nvim` (`lua/plugins/comment.lua`) - loads on `VeryLazy` so `gc` toggles are available once the UI settles.
- `mg979/vim-visual-multi` (`lua/plugins/multicursor.lua`) - defines a `\` leader with custom find-under, regex, and vertical cursor mappings.

## Buffers & Look-and-Feel
- `ojroques/nvim-bufdel` (`lua/plugins/bufdelete.lua`) - replaces bare `:bd`, keeping splits alive and hopping to the alternate buffer.
- `famiu/bufdelete.nvim` (`lua/plugins/bufferline.lua`) - helper layer Bufferline calls for close, right-click, and middle-click actions.
- `akinsho/bufferline.nvim` (`lua/plugins/bufferline.lua`) - UI tabline with `<Tab>`/`<S-Tab>` cycling, `<leader>bp` picking, and Bufdelete-backed close commands.
- `nvim-lualine/lualine.nvim` (`lua/plugins/lualine.lua`) - automatic theme-aware statusline; icons draw via Devicons.
- `EdenEast/nightfox.nvim` (`lua/plugins/colorscheme.lua`) - applies the Nightfox palette with italic/bold tweaks at startup.
- `petertriho/nvim-scrollbar` (`lua/plugins/scrollbar.lua`) - attaches on `BufReadPost` to render a thin scrollbar showing cursor position.
- `nvim-tree/nvim-web-devicons` (declared in multiple specs) - Nerd Font glyph provider for Bufferline, Lualine, and Neo-tree.

## Navigation & Discovery
- `nvimdev/dashboard-nvim` (`lua/plugins/dashboard.lua`) - Hyper startup screen on `VimEnter` with Telescope-powered shortcuts for updates, files, buffers, and grep.
- `nvim-neo-tree/neo-tree.nvim` (`lua/plugins/neo-tree.lua`) - `<leader>e` toggles filesystem, buffers, and git views with `C` descend and `X` ascend mappings.
- `nvim-telescope/telescope.nvim` (`lua/plugins/telescope.lua`) - fuzzy finder loaded by `:Telescope`, `<leader>ff`, or `<leader>fg`; depends on Plenary.
- `folke/which-key.nvim` (`lua/plugins/which-key.lua`) - `VeryLazy` hint popups that explain keybinding groups when idle.

## LSP & Language Features
- `williamboman/mason.nvim` (`lua/plugins/lsp.lua`) - installer UI for external LSP tools; `:MasonUpdate` runs on build.
- `williamboman/mason-lspconfig.nvim` (`lua/plugins/lsp.lua`) - ensures `lua_ls`, wiring shared handlers so added servers inherit defaults.
- `neovim/nvim-lspconfig` (`lua/plugins/lsp.lua`) - registers the client and buffer keymaps for goto, hover, rename, code actions, and diagnostics.
- `nvim-treesitter/nvim-treesitter` (`lua/plugins/treesitter.lua`) - runs `:TSUpdate` at install, enabling tree-sitter highlighting and indentation.

## Shared Libraries
- `nvim-lua/plenary.nvim` - async and filesystem helpers used by Telescope and Neo-tree.
- `MunifTanjim/nui.nvim` - UI primitives Neo-tree relies on for popups and layouts.

