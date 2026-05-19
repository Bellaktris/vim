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


" LSP diagnostics (native LSP only; YCM handles its own signs)
if exists('g:native_lsp') && g:native_lsp
  set cmdheight=0

  if has("nvim-0.5.0") || has("patch-8.1.1564")
    set signcolumn=number
  else
    set signcolumn=yes
  endif

  highlight! DiagnosticSignWarn ctermbg=NONE ctermfg=yellow guibg=NONE guifg=darkkhaki
  highlight! DiagnosticSignHint ctermbg=NONE ctermfg=gray guibg=NONE guifg=aquamarine
  highlight! DiagnosticSignInfo ctermbg=NONE ctermfg=gray guibg=NONE guifg=aquamarine
  highlight! DiagnosticSignError ctermbg=NONE ctermfg=red guibg=NONE guifg=red
  highlight! CursorLineNr guibg=NONE ctermbg=NONE guifg=yellow ctermfg=yellow
  highlight! NormalFloat term=bold cterm=bold ctermfg=DarkGreen ctermbg=gray
endif
