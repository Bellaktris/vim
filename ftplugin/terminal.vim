au BufWinEnter,WinEnter term://.* startinsert

setlocal noshowmode
setlocal noruler
" setlocal laststatus=0
setlocal noshowcmd

" if bufname('%') !~# '.*fzf/bin/fzf.*'
"     tnoremap <buffer> <C-[>gt <C-\><C-n>gt
"     tnoremap <buffer> <C-[>gT <C-\><C-n>gT
"     tnoremap <silent><buffer> <C-[>: <C-\><C-n>:
" endif
