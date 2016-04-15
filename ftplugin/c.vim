nnoremap <silent><buffer> gf :YcmCompleter GoToInclude<cr>

nmap <buffer> g] <Plug>(SmartGoTo)
nmap <buffer> g<c-]> <Plug>(SmartGoTo)
nmap <buffer> gd <Plug>(SmartGoTo)
nmap <buffer> gD <Plug>(SmartGoTo)

nmap <buffer> <leader>dl <Plug>(ShowDetailedLine)

nnoremap <silent><buffer> K :ViewDocMan <cword><cr>

if executable('fbgs')
  xmap <silent> <leader>ag y:execute "lcd ".helpers#find_git_root()<cr>
      \ :exe "Grepper -noprompt -grepprg fbgs -i -s "
      \ . helpers#shellescape(substitute(@0, '--', '', 'g'))<cr>

  command! -nargs=* FastGrep execute "Grepper -noprompt -grepprg fbgs -i -s ".helpers#shellescape('<args>')
endif  " executable('fbgs')
