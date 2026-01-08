vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,  -- 0 = buffer courant
  callback = function()
    require("go.format").goimports()
  end,
})

vim.treesitter.start()
