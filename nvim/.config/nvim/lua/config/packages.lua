-- Setup mapleader before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load all plugins using vim.pack
vim.pack.add({
  -- Telescope
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "v0.2.2" },
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/mrloop/telescope-git-branch.nvim",

  -- LSP
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",

  -- Completion
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",

  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",

  -- File tree
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/antosha417/nvim-lsp-file-operations",

  -- Git
  "https://github.com/lewis6991/gitsigns.nvim",

  -- Colorscheme
  "https://github.com/tanvirtin/monokai.nvim",

  -- Statusline
  "https://github.com/nvim-lualine/lualine.nvim",

  -- Formatting
  "https://github.com/stevearc/conform.nvim",

  -- Testing
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/antoinemadec/FixCursorHold.nvim",
  "https://github.com/rouge8/neotest-rust",
  "https://github.com/nvim-neotest/neotest-go",
  "https://github.com/arthur944/neotest-bun",
  "https://github.com/weilbith/neotest-gradle",

  -- Utilities
  "https://github.com/nmac427/guess-indent.nvim",
  { src = "https://github.com/ThePrimeagen/harpoon",          version = "harpoon2" },
  "https://github.com/brianhuster/live-preview.nvim",
  "https://github.com/SCJangra/table-nvim",
})
