return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
    	ensure_installed = {
    		"lua-language-server", "stylua",
    		"html-lsp", "css-lsp" , "prettier"
    	},
    },
  },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

  -- custom plugins
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
    },
    lazy = false,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  {
    "simrat39/rust-tools.nvim",
    lazy = false,
  },

   {
     'tpope/vim-fugitive',
     lazy = true, -- Only load when needed
   },
}
