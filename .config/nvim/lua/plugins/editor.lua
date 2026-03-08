return {
  { "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {},
  },
  { "christoomey/vim-tmux-navigator",
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>", "<C-\\>" },
  },
  { "tpope/vim-fugitive", cmd = "Git" },
  { "benomahony/uv.nvim",
    ft = "python",
    opts = {},
  },
}
