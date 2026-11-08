setlocal foldmethod=indent

setlocal tabstop=2
setlocal shiftwidth=2

call helpers#setup_goto_mappings()

" YCM answers GetDoc itself, or through pyright when that is registered.
if get(g:, 'use_ycm', 0)
  function! CloseOrMakeNewTab()
    if line2byte( line( '$' ) + 1 ) <= 2
      quit
      echohl WarningMsg | echom "No docs available..." | echohl None
    else
      wincmd T
    endif
  endfunction

  nmap <silent><buffer> K :YcmCompleter GetDoc<cr>
        \:wincmd P<cr>:call CloseOrMakeNewTab()<cr>
endif

nmap <silent><buffer> <leader>pdb Oimport ipdb; ipdb.set_trace()<esc>

