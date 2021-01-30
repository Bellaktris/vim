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

let s:smart_goto_guard = 0
let s:modified = 1

function! SmartGoTo()
  if s:smart_goto_guard == 0
    let s:smart_goto_guard = 1

    try
      let s:subcommands = pyeval('ycm_state.GetDefinedSubcommands()')
    catch
      let s:subcommands = py3eval('ycm_state.GetDefinedSubcommands()')
    endtry

    let s:goto_fallback = 'echohl WarningMsg | echo "smartgoto command '
            \. 'is not available for this file type" | echohl None'

    if index(s:subcommands, 'GoTo') >= 0
      let s:goto_fallback = 'YcmCompleter GoTo'
    else | if index(s:subcommands, 'GoToDefinition') >= 0
      let s:goto_fallback = 'YcmCompleter GoToDefinition'
    else | if index(s:subcommands, 'GoToDeclaration') >= 0
      let s:goto_fallback = 'YcmCompleter GoToDeclataion'
    endif | endif | endif

    let s:imprecise = index(s:subcommands, 'GoToImprecise')

    if s:imprecise >= 0
      augroup vimrcs_plugins_youcompleteme | au!
        au BufWritePre * let s:modified += &mod
      augroup END
    endif
  endif

  redir => g:ycm_last_message
  if s:imprecise >= 0 && !s:modified && !&mod
    execute 'YcmCompleter GoToImprecise'
  else
    execute s:goto_fallback
  endif
  redir END

  let s:lastmsg=get(split(g:ycm_last_message, "\n"), -1, "")
endfunction

nmap <silent> <Plug>(SmartGoTo) :call SmartGoTo()<cr>
