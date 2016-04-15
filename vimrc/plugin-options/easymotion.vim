hi! link EasyMotionTarget ErrorMsg
hi! link EasyMotionShade Comment

hi! link EasyMotionTarget2First MatchParen
hi! link EasyMotionTarget2Second MatchParen

hi! link EasyMotionMoveHL Search


let g:EasyMotion_enter_jump_first = 1

let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_mapping = 0
let g:EasyOperator_line_do_mapping = 0
let g:EasyMotion_do_shade = 0

nmap <silent> <Plug>(easyoperator-line-cut) :call s:CutLines()<cr>
nmap <silent> <Plug>(easyoperator-line-substitute) :call s:SubstituteLines()<cr>

function! s:CutLines()
    let orig_pos = [line('.'), col('.')]
    call easyoperator#line#selectlines()
    normal! x
    keepjumps call cursor(orig_pos[0], orig_pos[1])
endfunction

function! s:SubstituteLines()
    let orig_pos = [line('.'), col('.')]
    call easyoperator#line#selectlines()
    normal! p
    keepjumps call cursor(orig_pos[0], orig_pos[1])
endfunction
