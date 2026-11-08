-- nvim-treesitter's main branch only installs parsers and queries; highlighting
-- and folding are Neovim's own, and are switched on per buffer here.
--
-- A parser that is missing is installed the first time its filetype opens (the
-- old auto_install), which needs the tree-sitter CLI on PATH.

local ts = require('nvim-treesitter')

local function attach(buf, lang)
  if not pcall(vim.treesitter.start, buf, lang) then
    return false
  end
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[win][0].foldmethod = 'expr'
    vim.wo[win][0].foldenable = false
  end
  return true
end

local pending = {}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_options', { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang or attach(args.buf, lang) then
      return
    end
    if pending[lang] ~= nil or vim.fn.executable('tree-sitter') == 0
        or not vim.list_contains(ts.get_available(), lang) then
      return
    end
    pending[lang] = true
    ts.install(lang):await(function(err)
      vim.schedule(function()
        if err then
          pending[lang] = false -- failed: do not retry this session
          return
        end
        pending[lang] = nil
        if vim.api.nvim_buf_is_valid(args.buf) then
          attach(args.buf, lang)
        end
      end)
    end)
  end,
})
