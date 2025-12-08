return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang",
      "andythigpen/nvim-coverage",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang")({
            warn_test_name_dupes = false,
            -- Performance : désactive discovery automatique
            go_test_args = {
              "-v",
              "-race",
              "-count=1",
              "-timeout=60s",
              "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
            },
            discovery = {
              enabled = false,
            },
            runner = "go",  -- Utilise go directement
            testify_enabled = false,
          })
        },
        warn_test_name_dupes = false,
        output_panel = {
          enabled = false
        },
        discovery = {
          enabled = false,
        },
        diagnostic = {
          enabled = true, -- Affiche les erreurs inline, très utile
          severity = vim.diagnostic.severity.ERROR,
        },
        status = {
          virtual_text = false, -- Disable virtual text status
          signs = true, -- Enable signs in margin (gutter)
        },
        quickfix = {
          enabled =  false
        },
        floating = {
          border = "rounded",
          max_height = 0.99,
          max_width = 0.99,
          options = {}
        },
      })
    end,
  },
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("coverage").setup({
        auto_reload = true,
        lang = {
          go = {
            coverage_file = vim.fn.getcwd() .. "/coverage.out",
          },
        },
        signs = {
          covered = { hl = "CoverageCovered", text = "▎" },
          uncovered = { hl = "CoverageUncovered", text = "▎" },
          partial = { hl = "CoveragePartial", text = "▎" },
        },
        highlights = {
          covered = { fg = "#8ec07c" },   -- Green
          uncovered = { fg = "#fb4934" }, -- Red
        },
      })
    end,
    keys = {
      { "tc", "<cmd>Coverage<cr>", desc = "Show coverage" },
      { "ct", "<cmd>CoverageToggle<cr>", desc = "Toggle coverage" },
    },
  },
}
