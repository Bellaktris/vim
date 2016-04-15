function! DispatchAddNeovim()
    augroup dispatch-neovim | au!
    augroup END

    if index(get(g:, 'dispatch_handlers', ['neovim']), 'neovim') < 0
        call insert(g:dispatch_handlers, 'neovim', 0)
    endif
endfunction

function! MakePre()
  if bufname("%") != ""
    exec "noa w"
  endif

  if &makeprg == 'make'
    exec "Makeshift"
  endif
endfunction

command! -nargs=* -bang BMake
          \  call MakePre()
          \| silent! Make<bang> <args>

if exists(':Alias')
  Alias make BMake
endif
