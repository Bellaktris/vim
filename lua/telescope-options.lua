require('telescope').setup({
  defaults = {
    vimgrep_arguments = {
      "rg", "--color=never", "--no-heading", "--with-filename",
      "--line-number", "--column", "--smart-case",
    },
    mappings = {
      i = {
        ["<CR>"] = require("telescope.actions").select_tab
      },
      n = {
        ["<CR>"] = require("telescope.actions").select_tab
      }
    }
  },
  extensions = {
    fzf = {
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
      fuzzy = true,
    }
  },
  layout_config = {
    vertical = { width = 0.75 }
  }
})

require('telescope').load_extension("fzf")
