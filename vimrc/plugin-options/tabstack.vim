" let g:tabstack_index = 0
" let g:tabstack={}

" let g:tabstack_last_backpointer = -1
" let g:tabstack_prev = -1
" let g:tabstack_just_closed = 0

" function! s:UpdateTabStack()
"   for i in keys(g:tabstack)
"     if g:tabstack[i] > expand('<afile>')
"       let g:tabstack[i] -= 1
"     elseif g:tabstack[i] == expand('<afile>')
"       call remove(g:tabstack, i)
"     endif
"   endfor
" endfunction

" augroup tabstack | au!
"   au VimEnter,TabEnter *
"     \  if g:tabstack_just_closed != 1
"     \|   let t:tabstack_backpointer = g:tabstack_prev | endif
"     \| let g:tabstack_just_closed = 0
"     \| let g:tabstack_last_backpointer = t:tabstack_backpointer

"   au VimEnter,TabNewEntered *
"     \  let t:tabstack_index = g:tabstack_index
"     \| let g:tabstack_index += 1
"     \| let g:tabstack[t:tabstack_index] = tabpagenr()

"   au TabClosed *
"     \  let g:tabstack_just_closed = 1
"     \| call s:UpdateTabStack()
"     \| silent! exec "tabn " . g:tabstack[g:tabstack_last_backpointer]

"   au TabLeave * let g:tabstack_prev = t:tabstack_index
" augroup END
