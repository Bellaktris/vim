setlocal foldmethod=syntax
setlocal foldlevelstart=1

function! s:FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
endfunction
setlocal foldtext=s:FoldText()

if executable('xpbgs')
  xmap <silent> <leader>ag y:execute "lcd ".helpers#find_git_root()<cr>
      \ :exe "Grepper -noprompt -grepprg xpbgs -i -s "
      \ . helpers#shellescape(substitute(@0, '--', '', 'g'))<cr>

  command! -nargs=* FastGrep execute "Grepper -noprompt -grepprg xpbgs -i -s ".helpers#shellescape('<args>')
endif  " executable('xpbgs')
