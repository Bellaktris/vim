let g:airline#extensions#disable_rtp_load = 1

let g:airline_exclude_preview = 1

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_tab_type = 0

let g:airline#extensions#whitespace#checks = []

let g:airline_powerline_fonts = 1

" No separator character between sections. Powerline filled triangles render
" as opaque foreground glyphs even when iTerm2's transparency makes the
" section bgs semi-transparent, so the triangle visually pops out of the
" rest of the line. Dropping the character lets sections abut directly; each
" section's bg picks up the same terminal transparency uniformly.
let g:airline_left_sep  = ''
let g:airline_right_sep = ''

if has('gui') || exists('&termguicolors')
               \ && &termguicolors == 1
  let g:airline_theme="luna"
else | let g:airline_theme="silver" | endif

let g:airline#extensions#tabline#show_splits = 0

let g:airline#extensions#tabline#fnametruncate = 7
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'


let g:airline_extensions = ['tabline', 'branch', 'tagbar']

if exists('g:use_ycm') && g:use_ycm && has('python3')
  let g:airline_extensions += ['ycm']
elseif exists('g:lsp_servers') && !empty(g:lsp_servers) && has('nvim')
  let g:airline_extensions += ['nvimlsp']
  let g:airline#extensions#nvimlsp#enabled = 1
  let g:airline#extensions#nvimlsp#error_symbol = "✘"
  let g:airline#extensions#nvimlsp#warning_symbol = '!'
endif
