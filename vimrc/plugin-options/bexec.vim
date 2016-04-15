function! s:ExecuteFile()
  silent! wall

  let l:width = helpers#free_hspace()
  let l:width = l:width > 40 ? l:width : 40

  if has_key(g:bexec_filter_types, &filetype)
    let l:cmd = g:bexec_filter_types[&filetype]
          \ . ' ' . shellescape(expand('%:p'))
          \ . ' ' . g:bexec_args
  else
    let l:shebang = helpers#parse_shebang()
    if l:shebang.exe != ''
      let l:cmd = l:shebang.exe . ' ' . join(l:shebang.args)
            \ . ' ' . shellescape(expand('%:p'))
            \ . ' ' . g:bexec_args
    else
      let l:cmd = shellescape(expand('%:p'))
            \ . ' ' . g:bexec_args
    endif
  endif

  execute l:width . 'vsplit | terminal ' . l:cmd
  setlocal nonumber norelativenumber
  normal! G
endfunction

nmap <silent> <plug>(execute-file) :call <SID>ExecuteFile()<cr>
