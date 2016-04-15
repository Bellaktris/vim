let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

let g:formatters_python = ['autopep8']
let g:formatters_c = ['clang_format']
let g:formatters_cpp = ['clang_format']
let g:formatters_php = ['hackfmt']

let g:formatdef_hackfmt =
    \ "'hackfmt "
    \.  "--in-place'"

let g:formatdef_clang_format =
    \ "'clang-format "
    \.  "-style=file "
    \.  "-fallback-style=google'"
