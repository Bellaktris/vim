 setlocal nonumber
 setlocal colorcolumn=

 " Each entry stays on one line; cursor moves past the right edge scroll the
 " view sideways instead of wrapping.
 setlocal nowrap
 setlocal sidescroll=1
 setlocal sidescrolloff=8

 " Cursor-following highlight on the active qf entry. CursorLine is renamed
 " to a window-local group so source buffers (where starsky disables
 " CursorLine globally) aren't affected. QuickFixLine is suppressed here
 " because it only updates on :cnext/<CR> jumps and visually competes with
 " the cursor-following line.
 setlocal cursorline
 setlocal winhighlight=CursorLine:QfCursorLine,QuickFixLine:NONE
 highlight default link QfCursorLine ColorColumn

 " <CR> jumps to the entry under the cursor. Use .ll in loclist windows,
 " .cc in quickfix windows -- hard-coding .cc broke loclist jumps with
 " E42: No Errors.
 if get(getwininfo(win_getid())[0], 'loclist', 0)
   nnoremap <silent><buffer> <cr> :.ll<cr>
 else
   nnoremap <silent><buffer> <cr> :.cc<cr>
 endif
