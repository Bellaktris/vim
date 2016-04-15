if !has('python3') || !has('nvim')
  finish
endif

execute 'command! -nargs=1 PythonJedi python3 <args>'

let s:python_init = "python3 sys.path.insert(0, '"
        \ . g:vimrc_dir . "/plugin-options/')"

augroup vimrcs_plugins_jedi_init | au!
    au FileType python execute s:python_init
               \| execute "python3 import jedi_vim"
               \| au! vimrcs_plugins_jedi_init
augroup END

function! s:JediShowCallSignatures()
    PythonJedi jedi_vim.show_call_signatures()
endfunction

function! s:JediClearCallSignatures()
    PythonJedi jedi_vim.clear_call_signatures()
endfunction

function! s:JediConfigureCallSignatures()
    augroup jedi_call_signatures
        autocmd! * <buffer>
        autocmd InsertLeave <buffer> call s:JediClearCallSignatures()
        autocmd CursorMovedI <buffer> call s:JediShowCallSignatures()
    augroup END
endfunction

augroup vimrcs_plugins_jedi | au!
    au FileType python call s:JediConfigureCallSignatures()
augroup END
