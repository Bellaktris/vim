" nvim 0.13 ships multicursor natively (:help multicursor), older vim and nvim
" fall back to vim-visual-multi. Both keep the same entry points:
"   visual <C-n>  place a cursor at every occurrence of the selection
"   <C-x>         drop the cursor under the primary one, go to the next
"   <C-p>         drop the cursor under the primary one, go to the previous

if has('nvim-0.13')
  " Native defaults cover the rest: Q toggles a cursor, zq{motion} places one
  " at every target ("zq*" for the word under the cursor), q= toggles follow
  " mode, ]C and [C jump between cursors, CTRL-L clears, gQ restores. Note Q
  " no longer replays the last recorded register.

  function! s:MulticursorSelection() abort
    let l:reg = getreg('"', 1, v:true)
    let l:regtype = getregtype('"')

    normal! gvy
    let @/ = '\V' . substitute(escape(@", '\'), '\n', '\\n', 'g')

    call setreg('"', l:reg, l:regtype)
    call histadd('/', @/)

    normal! zqgn
  endfunction

  function! s:MulticursorActive() abort
    let l:namespace = nvim_create_namespace('nvim.multicursor')
    return !empty(nvim_buf_get_extmarks(0, l:namespace, 0, -1, {'limit': 1}))
  endfunction

  " <C-x> and <C-p> only take over while cursors are placed, otherwise they
  " keep their usual meaning (decrement, EasyClip swap-paste from
  " plugin/mappings.vim). Mapped on VimEnter so plugin/ has had its say first.
  function! s:MulticursorMaps() abort
    nnoremap <expr> <C-x> <SID>MulticursorActive() ? '2Q]C' : "\<C-x>"
    nmap <expr> <C-p> <SID>MulticursorActive() ? '2Q[C' : "\<Plug>EasyClipSwapPasteBackwards"
  endfunction

  xnoremap <silent> <C-n> :<c-u>call <SID>MulticursorSelection()<cr>

  augroup multicursor_maps | au!
    au VimEnter * ++once call <SID>MulticursorMaps()
  augroup END
else
  let g:VM_default_mappings = 0

  let g:VM_maps = {}
  let g:VM_maps['Find Under']         = '<C-n>'
  let g:VM_maps['Find Subword Under'] = '<C-n>'
  let g:VM_maps['Skip Region']        = '<C-x>'
  let g:VM_maps['Remove Region']      = '<C-p>'

  let g:VM_quit_after_leaving_insert_mode = 0
endif
