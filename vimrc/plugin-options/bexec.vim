let g:bexec_width_func = 'helpers#free_hspace'
let g:bexec_max_width = 73
let g:bexec_splitdir = 'ver'
let g:bexec_always_on_the_right = 1

nmap <silent> <plug>(execute-file) :noa wa<cr>:Bexec<cr>
