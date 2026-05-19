nnoremap <silent><buffer> gf :YcmCompleter GoToInclude<cr>
call helpers#setup_goto_mappings()
nmap <buffer> <leader>dl <Plug>(ShowDetailedLine)
nnoremap <silent><buffer> K :ViewDocMan <cword><cr>
call helpers#setup_grep('fbgs')
