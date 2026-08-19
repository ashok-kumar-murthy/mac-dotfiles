local map = vim.keymap.set
local telescope = require("telescope.builtin")

local function find_files(opts)
  telescope.find_files(vim.tbl_extend("force", {
    hidden = true,
    find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
  }, opts or {}))
end

map("n", "<leader>ff", find_files, { desc = "Find files" })
map("n", "<leader>fg", telescope.live_grep, { desc = "Search text" })
map("n", "<leader>fb", telescope.buffers, { desc = "Find buffers" })
map("n", "<leader>fh", telescope.help_tags, { desc = "Search help" })
map("n", "<leader>fr", telescope.oldfiles, { desc = "Recent files" })
map("n", "<leader>fw", telescope.grep_string, { desc = "Search word under cursor" })
map("n", "<leader>fc", function()
  find_files({ cwd = vim.fn.stdpath("config"), prompt_title = "Neovim config" })
end, { desc = "Find Neovim config" })
map("n", "<leader>e", "<cmd>Oil<cr>", { desc = "File explorer" })
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "<leader>s", "<cmd>write<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })

map("n", "<leader>bb", telescope.buffers, { desc = "Choose buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

map("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split below" })
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split right" })
map("n", "<leader>ww", "<C-w>w", { desc = "Next window" })
map("n", "<leader>wh", "<C-w>h", { desc = "Window left" })
map("n", "<leader>wj", "<C-w>j", { desc = "Window below" })
map("n", "<leader>wk", "<C-w>k", { desc = "Window above" })
map("n", "<leader>wl", "<C-w>l", { desc = "Window right" })
map("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Only window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })

map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrap" })
map("n", "<leader>ul", function()
  vim.wo.list = not vim.wo.list
end, { desc = "Toggle whitespace" })

map("n", "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle Markdown render" })
map("n", "<leader>mv", "<cmd>RenderMarkdown preview<cr>", { desc = "Markdown side preview" })
map("n", "<leader>mg", function()
  vim.cmd("tabnew | terminal glow " .. vim.fn.shellescape(vim.fn.expand("%:p")))
end, { desc = "Preview Markdown with Glow" })
