vim.g.mapleader = ";"

vim.cmd("syntax off")

vim.opt.laststatus = 3

-- enable mouse for all modes
vim.opt.mouse = ''

vim.opt.encoding = 'UTF-8'
vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.textwidth = 100

-- delete trailing whitespace on save for all files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

vim.cmd('filetype plugin indent on')

require("config.lazy")

vim.cmd([[
" nerdcommenter
let g:NERDSpaceDelims = 1

set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<
set t_Co=256

set nu
set ruler
set list
set showmatch
set hlsearch
set nocompatible
set wildmenu
set incsearch

func! DeleteNewLineEndOfFile()
set binary
set noeol
endfunc

" Line Break
:nnoremap <NL> i<CR><ESC>

" Rename current word
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" Set spell
:nnoremap <Leader>sc :setlocal spell spelllang=en_us

" DAP
nnoremap <leader>db <cmd>lua require'dap'.toggle_breakpoint()<cr>
nnoremap <leader>dc <cmd>lua require'dap'.continue()<cr>
nnoremap <leader>ds <cmd>lua require("dapui").setup()
nnoremap <leader>dc <cmd>lua require("dapui").close()

" Neotest mappings
nmap tf <cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>
nmap tn <cmd>lua require("neotest").run.run()<cr>
nmap ts <cmd>lua require("neotest").summary.toggle()<cr>
nmap to <cmd>lua require("neotest").output.open({ enter = false })<cr>

" Dap mapping for tests
nmap td <cmd>lua require('dap-go').debug_test()<cr>
nmap ti <cmd>lua require("dapui").float_element()<cr>

nnoremap <silent>[t <cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>
nnoremap <silent>]t <cmd>lua require("neotest").jump.next({ status = "failed" })<CR>
]])

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
-- Telescope end

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "ipkg" },
  highlight = {
    enable = true,
  },
}

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 10
vim.opt.foldnestmax = 6
-- Treesitter end

--- LSP
--- Go
vim.lsp.config("gopls", {
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = false,
      codelenses = {
        generate = false,
        gc_details = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = false,
      },
    },
  },
})
vim.lsp.enable({"gopls"})

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },

})

--- golangci-lint
golangci_lint_binary = "golangci-lint"

if vim.fn.executable('custom-gcl') == 1 then
  golangci_lint_binary = 'custom-gcl'
end

vim.lsp.config("golangci_lint_ls", {
  cmd = { 'golangci-lint-langserver' },
  filetypes = {'go', 'gomod'},
  root_markers = { '.golangci.yml', '.git', 'go.mod' },
  init_options = {
    command = {
      golangci_lint_binary,
      "run",
      "--output.json.path",
      "stdout",
      "--issues-exit-code=1",
      "--show-stats=false"
    },
  },
})
vim.lsp.enable({"golangci_lint_ls"})

--- Bindings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(e)
    local bufopts = { buffer = e.buf }
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
  end,
})
--- LSP end

-- Go
require('go').setup({})
-- Go end

-- Cursorline
require('nvim-cursorline').setup {
  cursorline = {
    enable = true,
    timeout = 1000,
    number = false,
  },
  cursorword = {
    enable = false,
  }
}
-- Cursorline end

-- Lualine
require('lualine').setup{
  options = {
    theme = 'tokyonight',
    extensions = { 'fugitive' },
  }
}

require'nvim-web-devicons'.setup {}
