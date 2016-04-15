if exists('b:did_ftplugin') | finish | endif

let b:did_ftplugin=1

function! GotoCurrentLine()
  let l:pos = getcurpos()
  exec "normal! gg"
  call cursor([b:data[0], l:pos[-3], l:pos[-2], l:pos[-1]])
  let b:last_goto = line('.')
endfunction

function! SetLineMarker()
  exec "sign unplace 1 file=" . expand("%:p")
  exec "sign place 1 line=" . b:data[0] . " name=current_line file=" . expand("%:p")
endfunction

let b:num_signs = 1

function! SetBreakpointMarkers()
  let l:until = b:num_signs
  let b:num_signs = 2

  for l:line in b:data[1:]
    if l:line != b:data[0]
      exec "sign unplace " . b:num_signs . " file=" . expand("%:p")
      exec "sign place " . b:num_signs . " line=" . l:line . " name=breakpoint file=" . expand("%:p")
      let b:num_signs = b:num_signs + 1
    endif
  endfor

  let l:line = len(b:data) + 1
  while l:line <= l:until
    if l:line != b:data[0]
      exec "sign unplace " . l:line . " file=" . expand("%:p")
    endif
    let l:line = l:line + 1
  endwhile
endfunction

let b:last_goto = -1

function! OnChange(args)
  if &ft[:8] == 'gdbsource' && filereadable(expand('%:p') . '.data')
    let b:data = readfile(expand('%:p') . '.data')

    if len(b:data) == 0
      return
    endif

    doautocmd FocusGained

    call SetLineMarker() |  call SetBreakpointMarkers()

    if b:data[0] != b:last_goto | call GotoCurrentLine() | endif
  endif

  let b:timer = timer_start(80, function('OnChange'))
endfunction

let b:timer = timer_start(80, function('OnChange'))

nmap <silent><buffer> <leader>ln :call GotoCurrentLine()<cr>

set autoread | set nomodifiable | set number
set laststatus=0 | set colorcolumn=

sign define current_line text=⟹  texthl=NeomakeWarningSign
sign define breakpoint text=▪  texthl=NeomakeInfoSign

function! TmuxDo(s, redraw_opt)
  call system("tmux send-keys -t 1 '" . a:s . "'; tmux send-keys -t 1 Enter")

  if a:redraw_opt == 1
    call system("tmux send-keys -t 1 'dashboard'; tmux send-keys -t 1 Enter")
  endif

  " call system("tmux send-keys -t 1 'shell clear'; tmux send-keys -t 1 Enter")
  return "\<esc>"
endfunction

function! QuitAll()
  call TmuxDo('exit', 0)
endfunction

function! GetBreakCMD()
  let l:cl = line('.')
  for bp in b:data[1:]
    if bp == l:cl
      return 'quiet clear'
    endif
  endfor
  return 'quiet break'
endfunction

noremap <silent><buffer><expr> <F10> TmuxDo('quiet next', 0)
noremap <silent><buffer><expr> <F12> TmuxDo('quiet step', 0)
noremap <silent><buffer><expr> <F5> TmuxDo('quiet continue', 0)
noremap <silent><buffer><expr> <S-F5> TmuxDo('quiet start', 0)

noremap <silent><buffer><expr> <F9> TmuxDo(GetBreakCMD() . " ". line('.'), 1)

let prefixes = [
      \'q', 'qu', 'qui', 'quit', 'quita', 'quital',
      \'wqall', 'qa', 'qal', 'qall', 'exi', 'exit',
      \'exita', 'exitall', 'wqal', 'x', 'xa', 'wq',
      \'xall', 'xal', 'wqa', 'exital', 'quitall',
\]

for prefix in prefixes
  exec "cnoremap <silent><buffer> " . prefix . "<cr> <c-r>=(getcmdtype()==':'"
      \ . " && getcmdpos()==1 ? 'call QuitAll()' : "
      \ . prefix . ")<cr><cr>"
endfor
