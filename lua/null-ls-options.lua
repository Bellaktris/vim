vim.fn.sign_define("DiagnosticUnderlineError", { text = "✘", texthl = "DiagnosticUnderlineError", numhl="", linehl="" })
vim.fn.sign_define("DiagnosticUnderlineWarn", { text = "✘", texthl = "DiagnosticUnderlineWarn", numhl="", linehl="" })
vim.fn.sign_define("DiagnosticUnderlineInfo", { text = "!", texthl = "DiagnosticUnderlineInfo", numhl="", linehl="" })
vim.fn.sign_define("DiagnosticUnderlineHint", { text = "i", texthl = "DiagnosticUnderlineHint", numhl="", linehl="" })
vim.fn.sign_define("DiagnosticSignError", { text = "✘", texthl = "DiagnosticSignError", numhl="", linehl="" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "✘", texthl = "DiagnosticSignWarn", numhl="", linehl="" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "!", texthl = "DiagnosticSignInfo", numhl="", linehl="" })
vim.fn.sign_define("DiagnosticSignHint", { text = "i", texthl = "DiagnosticSignHint", numhl="", linehl="" })

on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rf', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.diagnostic.setqflist({ open = false })
  vim.diagnostic.show(nil, 0)
end

vim.diagnostic.config({
    severity_sort = true,
    virtual_text = false,
    underline = false,
    signs = true,
    float = {
      format = function(d) return string.format("[%s] (%s)", d.source, d.message) end,
      border = "single",
    },
})

vim.cmd[[
  autocmd CursorHold * lua vim.diagnostic.open_float({ scope = "line", border = "single", focusable = false })
  autocmd DiagnosticChanged * lua vim.diagnostic.setqflist({open = false })
]]

require('null-ls').setup({
  on_attach = on_attach,
  sources = {},
})
