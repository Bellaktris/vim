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

function! SmartGoTo()
  try
    let l:subcommands = py3eval('ycm_state.GetDefinedSubcommands()')
  catch
    echohl WarningMsg | echo "YCM not available for this buffer" | echohl None
    return
  endtry

  if index(l:subcommands, 'GoTo') >= 0
    YcmCompleter GoTo
  elseif index(l:subcommands, 'GoToDefinition') >= 0
    YcmCompleter GoToDefinition
  elseif index(l:subcommands, 'GoToDeclaration') >= 0
    YcmCompleter GoToDeclaration
  else
    echohl WarningMsg | echo "No GoTo command available for this file type" | echohl None
  endif
endfunction

nmap <silent> <Plug>(SmartGoTo) :call SmartGoTo()<cr>

