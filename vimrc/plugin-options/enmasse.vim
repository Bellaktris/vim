function! EnMasse()
    if &ft ==# 'qf'
        execute "normal! :EnMasse\<cr>\<cr>"
        wincmd p | quit
    endif
endfunction

