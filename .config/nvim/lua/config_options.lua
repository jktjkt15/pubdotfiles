vim.cmd([[syntax on]])
vim.cmd([[set mouse=]])

vim.g.mapleader = ","
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 2
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.relativenumber = false
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
vim.opt.cmdheight = 0

vim.opt.swapfile = false

vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true
-- set spelllang=en,fr
vim.opt.spell = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.showmode = true
vim.opt.cursorline = true
vim.opt.linebreak = true
vim.opt.enc = "utf-8"
vim.opt.fileencodings = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.foldenable = false
vim.opt.ignorecase = true
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.pumblend = 0
vim.opt.pumheight = 10
vim.opt.scrolloff = 8
vim.opt.re = 0
vim.opt.fillchars = "eob: "
vim.opt.title = true
vim.opt.titlestring = "neovim"

vim.opt.diffopt = { "internal", "vertical", "closeoff", "filler" }
vim.opt.shm:append("I")

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = vim.api.nvim_create_augroup("BufSettings", { clear = true }),
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

vim.opt.shell = "fish"
vim.opt.guicursor = "n-v-c-sm:block-nCursor,i-ci-ve:ver25,r-cr-o:hor20"
vim.diagnostic.config({
	virtual_text = { true },
	virtual_lines = { current_line = true },
	signs = true,
	underline = true,
})
vim.lsp.inlay_hint.enable(false)
