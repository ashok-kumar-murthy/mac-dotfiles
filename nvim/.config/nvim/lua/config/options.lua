local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 200
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

local theme_file = vim.fn.expand("~/.cache/modus-theme/current")
local theme = "operandi"
if vim.fn.filereadable(theme_file) == 1 then
  theme = vim.trim(vim.fn.readfile(theme_file)[1] or theme)
end
opt.background = theme == "vivendi" and "dark" or "light"
vim.cmd.colorscheme("modus_" .. (theme == "vivendi" and "vivendi" or "operandi"))
