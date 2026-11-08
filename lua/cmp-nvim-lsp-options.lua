local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
  }),
  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lsp' },
    },
    {
      { name = 'buffer' },
    }
  )
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources(
    {
      { name = 'buffer' },
    }
  )
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    {
      { name = 'path' }
    },
    {
      { name = 'cmdline' }
    }
  )
})

local servers = vim.g.lsp_servers or {}
if #servers > 0 then
  local lsp_attach = require('lsp-on-attach')
  local capabilities = require('cmp_nvim_lsp').default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )

  -- nvim-lspconfig only supplies the lsp/<server>.lua defaults now; nvim 0.11+
  -- merges these on top and starts the server itself.
  for _, srv in ipairs(servers) do
    vim.lsp.config(srv, {
      capabilities = capabilities,
      on_attach = lsp_attach.on_attach
    })
    vim.lsp.enable(srv)
  end
end
