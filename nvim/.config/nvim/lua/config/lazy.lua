local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    opts = { style = "modus_operandi", transparent = false },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
      treesitter.install({
        "bash", "css", "diff", "git_config", "gitcommit", "go", "html", "javascript",
        "json", "lua", "markdown", "markdown_inline", "python", "rust", "toml",
        "tsx", "typescript", "vim", "vimdoc", "yaml",
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
          -- Telescope's Treesitter preview adapter targets the old Treesitter
          -- API. Neovim's native syntax preview remains enabled instead.
          preview = { treesitter = false },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = "",
        component_separators = "│",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "stevearc/oil.nvim", opts = {} },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>b", group = "Buffers" },
        { "<leader>f", group = "Find" },
        { "<leader>m", group = "Markdown" },
        { "<leader>u", group = "Toggle" },
        { "<leader>w", group = "Windows" },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "markdown.mdx" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading = { sign = false, width = "block" },
      code = { sign = false, width = "block", border = "thin" },
      checkbox = { enabled = true },
      bullet = { enabled = true },
    },
  },
}, {
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
})
