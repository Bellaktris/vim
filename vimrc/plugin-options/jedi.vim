let s:python_exec = 'python3'

let jedi#call_signature_escape = '?!?'
execute 'command! -nargs=1 PythonJedi '.s:python_exec.' <args>'

let s:python_init = s:python_exec . " sys.path.insert(0, '"
        \ . g:vimrc_dir . "/plugin-options/')"

augroup vimrcs_plugins_jedi_init | au!
    au FileType python execute s:python_init
               \| execute s:python_exec . " import jedi_vim"
               \| au! vimrcs_plugins_jedi_init
augroup END

function! jedi#_vim_exceptions(str, is_eval)
    let l:result = {}
    try
        if a:is_eval
            let l:result.result = eval(a:str)
        else
            execute a:str
            let l:result.result = ''
        endif
    catch
        let l:result.exception = v:exception
        let l:result.throwpoint = v:throwpoint
    endtry
    return l:result
endfunction


let s:show_call_signatures_last = [0, 0, '']
function! s:JediShowCallSignatures()
    let [line, col] = [line('.'), col('.')]
    let curline = getline(line)
    let reload_signatures = 1

    " Caching.  On the same line only.
    if line == s:show_call_signatures_last[0]
        " Check if the number of commas and parenthesis before or after the
        " cursor has not changed since the last call, which means that the
        " argument position was not changed and we can skip repainting.
        let prevcol = s:show_call_signatures_last[1]
        let prevline = s:show_call_signatures_last[2]

        if substitute(curline[:col-2], '[^,()]', '', 'g')
                \ == substitute(prevline[:prevcol-2], '[^,()]', '', 'g')
                \ && substitute(curline[(col-2):], '[^,()]', '', 'g')
                \ == substitute(prevline[(prevcol-2):], '[^,()]', '', 'g')
        let reload_signatures = 0
        endif
    endif

    let s:show_call_signatures_last = [line, col, curline]

    if reload_signatures
        PythonJedi jedi_vim.show_call_signatures()
    endif
endfunction


function! s:JediClearCallSignatures()
    let s:show_call_signatures_last = [0, 0, '']
    PythonJedi jedi_vim.clear_call_signatures()
endfunction

function! s:JediConfigureCallSignatures()
    let b:jedi_syntax_guard = 0

    augroup jedi_call_signatures
        autocmd! * <buffer>
        autocmd InsertEnter <buffer> let s:show_call_signatures_last = [0, 0, '']
        autocmd InsertLeave <buffer> call s:JediClearCallSignatures()
        autocmd CursorMovedI <buffer> call s:JediShowCallSignatures()
    augroup END
endfunction

augroup vimrcs_plugins_jedi | au!
    au FileType python call s:JediConfigureCallSignatures()
augroup END
