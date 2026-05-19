if !exists('g:native_lsp') || !g:native_lsp
  finish
endif

nmap <silent> <leader>cp :execute 'Telescope find_files cwd='.helpers#find_git_root()<cr>

xnoremap <silent> <leader>ag "zy:execute 'Telescope live_grep cwd='.helpers#find_git_root().' default_text='.escape(@z, ' ')<cr>
xnoremap <silent> <leader>gp "zy:execute 'Telescope live_grep default_text='.escape(@z, ' ')<cr>

nmap <leader>ag :execute 'Telescope live_grep cwd='.helpers#find_git_root()<cr>
nmap <leader>gp :execute 'Telescope live_grep'<cr>
