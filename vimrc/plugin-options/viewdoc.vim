let g:viewdoc_openempty = 0
let g:no_plugin_maps = 1

if exists(':Alias')
  call Alias(0, 'help', 'ViewDocHelp')
  call Alias(0, 'man', 'ViewDocMan')
endif

nnoremap <silent> K :ViewDoc <cword><cr>

augroup vimrcs_plugins_viewdoc | au!
    au BufEnter [Doc* setlocal colorcolumn=0
augroup END
