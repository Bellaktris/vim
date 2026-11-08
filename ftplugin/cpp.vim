call helpers#setup_goto_mappings()
nmap <buffer> [m <Plug>(YcmGoToCurrentTagStart)
nmap <buffer> ]m <Plug>(YcmGoToCurrentTagEnd)
nmap <buffer> <leader>dl <Plug>(ShowDetailedLine)
nnoremap <silent><buffer> K :ViewDocMan std::<cword><cr>
