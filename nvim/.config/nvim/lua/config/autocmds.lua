local group = vim.api.nvim_create_augroup("UserMarkdown", { clear = true })

local yank_group = vim.api.nvim_create_augroup("UserYankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "markdown", "markdown.mdx" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bash", "css", "diff", "git_config", "gitcommit", "go", "html", "javascript",
    "json", "lua", "markdown", "markdown_inline", "python", "rust", "toml",
    "tsx", "typescript", "vim", "vimdoc", "yaml",
  },
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
