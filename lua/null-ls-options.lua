local lsp = require('lsp-on-attach')

require('null-ls').setup({
  on_attach = lsp.on_attach,
  sources = {},
})
