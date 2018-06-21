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

if has('gui') || exists('&termguicolors')
               \ && &termguicolors == 1
  let g:airline_theme="luna"
else | let g:airline_theme="silver" | endif

let g:airline#extensions#tabline#show_splits = 0

let g:airline#extensions#tabline#fnametruncate = 7
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'


let g:airline_extensions = ['tabline', 'branch', 'tagbar', 'ycm']
