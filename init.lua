vim.g.mapleader = ";"

-- enable mouse for all modes
vim.opt.mouse = 'a'

vim.opt.encoding = 'UTF-8'
vim.opt.termguicolors = true

vim.cmd('filetype plugin indent on')

require("config.lazy")

vim.cmd([[
		" nerdcommenter
		let g:NERDSpaceDelims = 1

		syntax enable

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

		" Default Indent & linesize
		set tabstop=2
		set shiftwidth=2
		set softtabstop=2
		set textwidth=100

		func! DeleteTrailingWS()
		exe "normal mz"
		%s/\s\+$//ge
		exe "normal `z"
		endfunc

		func! DeleteNewLineEndOfFile()
		set binary
		set noeol
		endfunc

		" GO
		au FileType go set noexpandtab
		au FileType go set shiftwidth=4
		au FileType go set softtabstop=4
		au FileType go set tabstop=4

		" Go
		autocmd BufWrite *.go :call DeleteTrailingWS()

		" Python
		autocmd BufWrite *.py :call DeleteTrailingWS()
		autocmd Filetype python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=80 expandtab autoindent colorcolumn=88 fileformat=unix

		" Puppet
		au BufNewFile,BufRead *.pp set filetype=puppet
		autocmd BufWrite *.pp :call DeleteTrailingWS()
		autocmd Filetype puppet setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=80 expandtab autoindent colorcolumn=80 fileformat=unix

		autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=140 expandtab autoindent colorcolumn=140 fileformat=unix
		" c
		autocmd FileType c setlocal shiftwidth=8 tabstop=8 softtabstop=8 textwidth=140
		autocmd BufWrite *.c :call DeleteTrailingWS()

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

		" Ultest mappings
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

vim.cmd[[colorscheme tokyonight]]

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

--- golangci-lint
golangci_lint_binary = "golangci-lint"

if vim.fn.executable('custom-gcl') == 1 then
	golangci_lint_binary = 'custom-gcl'
end

vim.lsp.config("golangci_lint_ls", {
	filetypes = {'go'},
	cmd = { 'golangci-lint-langserver' },
	filetypes = { 'go', 'gomod' },
	init_options = {
		command = { golangci_lint_binary, "run", "--output.json.path", "stdout", "--show-stats=false", "--issues-exit-code=1" },
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
