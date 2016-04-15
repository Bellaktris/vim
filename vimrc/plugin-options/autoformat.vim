let g:formatters_python = ['autopep8']
let g:formatters_c = ['clang_format']
let g:formatters_cpp = ['clang_format']

let g:formatdef_clang_format =
    \ "'clang-format "
    \.  "-style=file "
    \.  "-fallback-style=google'"
