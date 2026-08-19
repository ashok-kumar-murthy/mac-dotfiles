vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Telescope still checks this pre-0.12 compatibility helper.
if not vim.islist then
  vim.islist = vim.tbl_islist
end

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
