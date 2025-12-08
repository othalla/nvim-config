vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = 0,
      callback = function()
        require("go.format").goimports()
      end,
    })
  end,
})
