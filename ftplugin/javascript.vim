setlocal foldmethod=syntax
setlocal foldlevelstart=1

function! s:FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
endfunction
setlocal foldtext=s:FoldText()

call helpers#setup_grep('xpbgs')
