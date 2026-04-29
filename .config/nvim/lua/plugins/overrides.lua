return {
  -- snacks: show hidden files and search case-insensitively in the explorer
  { "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            matcher = {
              ignorecase = true,
              smartcase = false,
            },
          },
        },
      },
    },
  },
  -- telescope: include hidden files in live_grep
  { "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        vimgrep_arguments = {
          "rg", "--color=never", "--no-heading", "--with-filename",
          "--line-number", "--column", "--smart-case", "--hidden",
        },
      },
    },
  },
  -- conform: formatter config
  { "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        css = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
      },
    },
  },
}
