if has('nvim') && !exists('g:ycm_neovim_ns_id')
  let g:ycm_neovim_ns_id = nvim_create_namespace('YouCompleteMe')
endif

let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1

let g:ycm_confirm_extra_conf = 1

let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1

let g:ycm_key_detailed_diagnostics = '<Plug>(ShowDetailedLine)'
let g:ycm_goto_buffer_command = 'new-or-existing-tab'
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_echo_current_diagnostic = 1

let g:ycm_disable_for_files_larger_than_kb = 1024 * g:largefile_trigger_size

let g:ycm_global_ycm_extra_conf = g:vimrc_dir.'/plugin-options/ycm_extra_conf.py'

let g:ycm_last_message = ''

let g:ycm_error_symbol = '✘'
let g:ycm_warning_symbol = '✘'

" Wire g:lsp_servers into YCM's g:ycm_language_server.
" Servers with built-in YCM support (clangd, gopls, rust-analyzer, tsserver)
" are handled by YCM's install flags and don't need entries here.
let s:ycm_builtin = ['clangd', 'gopls', 'rust_analyzer', 'ts_ls', 'tsserver']
let s:ycm_server_map = {
  \ 'pyright':   {'cmd': ['pyright-langserver', '--stdio'], 'ft': ['python']},
  \ 'pylsp':     {'cmd': ['pylsp'],                         'ft': ['python']},
  \ 'lua_ls':    {'cmd': ['lua-language-server'],           'ft': ['lua']},
  \ 'bashls':    {'cmd': ['bash-language-server', 'start'], 'ft': ['sh', 'bash', 'zsh']},
  \ 'vimls':     {'cmd': ['vim-language-server', '--stdio'], 'ft': ['vim']},
  \ 'jsonls':    {'cmd': ['vscode-json-language-server', '--stdio'], 'ft': ['json']},
  \ 'yamlls':    {'cmd': ['yaml-language-server', '--stdio'], 'ft': ['yaml']},
  \ 'cssls':     {'cmd': ['vscode-css-language-server', '--stdio'], 'ft': ['css', 'scss', 'less']},
  \ 'html':      {'cmd': ['vscode-html-language-server', '--stdio'], 'ft': ['html']},
  \ }

if exists('g:lsp_servers') && !empty(g:lsp_servers)
  if !exists('g:ycm_language_server')
    let g:ycm_language_server = []
  endif

  for s:srv in g:lsp_servers
    if index(s:ycm_builtin, s:srv) >= 0
      continue
    endif
    if has_key(s:ycm_server_map, s:srv)
      let s:cfg = s:ycm_server_map[s:srv]
      call add(g:ycm_language_server, {
        \ 'name': s:srv,
        \ 'cmdline': s:cfg.cmd,
        \ 'filetypes': s:cfg.ft,
        \ })
    endif
  endfor
endif

