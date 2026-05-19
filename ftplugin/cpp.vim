call helpers#setup_goto_mappings()
nmap [m <Plug>(YcmGoToCurrentTagStart)
nmap ]m <Plug>(YcmGoToCurrentTagEnd)
nmap <buffer> <leader>dl <Plug>(ShowDetailedLine)
nnoremap <silent><buffer> K :ViewDocMan std::<cword><cr>
call helpers#setup_grep('fbgs')
