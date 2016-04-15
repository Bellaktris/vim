"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> Colorscheme
"    -> Disable scrollbars
"    -> Set font and font size
"    -> Window splitter
"    -> Height of the command bar
"    -> Always show current position
"    -> Show line numbers
"    -> Color column
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
set background=dark
colorscheme starsky


" Cursor shape (doesn't quite work)
" if has('nvim')
"   let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
" elseif empty($TMUX)
"   let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"   let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"   let &t_SR = "\<Esc>]50;CursorShape=2\x7"
" else
"   let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"   let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"   let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
" endif


" Disable scrollbars (real hackers
" don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L


" Window splitter
set fillchars=vert:│


" Height of the command bar
set cmdheight=1


" Always show current position
set ruler


" Show line numbers
set number
set cursorline


" Color column
let g:colorcolumn=80
set colorcolumn=80
