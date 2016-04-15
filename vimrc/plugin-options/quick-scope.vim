function! s:QuickScopeToggleFunc()
  if !exists('g:qs_enable') | return | endif

  if &modifiable == 1 && g:qs_enable == 0
    execute "QuickScopeToggle"
  endif

  if &modifiable == 0 && g:qs_enable == 1
    execute "QuickScopeToggle"
  endif
endfunction

augroup vimrc_quick_scope | au!
  au User Grepper call s:QuickScopeToggleFunc()
  au FileType,BufEnter * call s:QuickScopeToggleFunc()

augroup END
