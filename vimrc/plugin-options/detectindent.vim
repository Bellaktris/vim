let g:detectindent_preferred_indent = 2
let g:detectindent_preferred_when_mixed = 1
let g:detectindent_max_lines_to_analyse = 1024

let g:detectindent_min_indent = 2
let g:detectindent_max_indent = 8

augroup vimrcs_plugins_detectindent | au!
  au! VimEnter,BufEnter * if exists(':DetectIndent') | DetectIndent | endif
augroup END
