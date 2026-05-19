vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldmethod = 'expr'
vim.opt.foldenable = false

require('nvim-treesitter.configs').setup {
  highlight = {
    additional_vim_regex_highlighting = false,
    enable = true
  },
  sync_install = false,
  auto_install = true,
  ensure_installed = {
    -- "gitcommit",
    -- "graphql",
    -- "vimdoc",
    -- "python",
    -- "latex",
    -- "ninja",
    -- "cmake",
    -- "make",
    -- "hack",
    -- "bash",
    -- "cuda",
    -- "diff",
    -- "html",
    -- "java",
    -- "json",
    -- "objc",
    -- "rust",
    -- "ruby",
    -- "lua",
    -- "cpp",
    -- "vim",
    -- "c"
  }
}
