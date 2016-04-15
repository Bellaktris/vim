setlocal foldmethod=indent

setlocal tabstop=2
setlocal shiftwidth=2

if helpers#parse_shebang().exe ==# 'python'
  let b:neomake_python_pylint_exe = 'python'
  let b:neomake_python_flake8_exe = 'python'
endif

nmap <silent><buffer> g] <Plug>(SmartGoTo)
nmap <silent><buffer> g<c-]> <Plug>(SmartGoTo)
nmap <silent><buffer> gd <Plug>(SmartGoTo)
nmap <silent><buffer> gD <Plug>(SmartGoTo)

function! CloseOrMakeNewTab()
  if line2byte( line( '$' ) + 1 ) <= 2
    quit
    echohl WarningMsg | echom "No docs available..." | echohl None
  else
    wincmd T
  endif
endfunction

nmap <silent><buffer> <leader>pdb Oimport ipdb; ipdb.set_trace()<esc>

nmap <silent><buffer> K :YcmCompleter GetDoc<cr>
      \:wincmd P<cr>:call CloseOrMakeNewTab()<cr>

