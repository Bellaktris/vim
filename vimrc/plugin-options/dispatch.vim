function! MakePre()
  if bufname('%') != ''
    exec 'noa w'
  endif

  if &makeprg == 'make'
    for [file, prg] in items(g:build_systems)
      let root = findfile(file, '.;')
      if root != ''
        let &makeprg = prg
        exec 'lcd' fnameescape(fnamemodify(root, ':p:h'))
        break
      endif
    endfor
  endif
endfunction

command! -nargs=* -bang BMake
          \  call MakePre()
          \| Neomake! <args>

if exists(':Alias')
  call Alias(0, 'make', 'BMake')
endif
