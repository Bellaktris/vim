let g:makeshift_on_startup = 0
let g:makeshift_on_bufenter = 0

let g:makeshift_chdir = 1

let g:makeshift_on_bufread = 0
let g:makeshift_on_bufnewfile = 0

if executable('ninja')
  let g:makeshift_systems = {
    \ 'CMakeLists.txt': 'mkdir -p build'
                 \. ' && cd build'
                 \. ' && cmake -G Ninja ..'
                 \. ' && ninja',
  \}
else
  let g:makeshift_systems = {
    \ 'CMakeLists.txt': 'mkdir -p build'
                 \. ' && cd build'
                 \. ' && cmake .. && make',
  \}
endif

let g:makeshift_systems['BUILD'] =
  \'blaze build --color=no --curses=no'

let g:makeshift_systems['TARGETS'] =
  \'buck build @mode/opt /${PWD#$HOME/fbsource/fbcode}/...'
