let s:e = g:jedi#call_signature_escape

let s:full = s:e.'jedi=.\{-}'.s:e.'.\{-}'.s:e.'jedi'.s:e
let s:ignore = s:e.'jedi.\{-}'.s:e
execute 'syn match jediIgnore "'.s:ignore.'" contained conceal'
setlocal conceallevel=2
syntax match jediFatSymbol "\*_\*" contained conceal
syntax match jediFat "\*_\*.\{-}\*_\*" contained contains=jediFatSymbol
syntax match jediSpace "\v[ ]+( )@=" contained
execute 'syn match jediFunction "'.s:full.'" keepend extend '
            \ .' contains=jediIgnore,jediFat,jediSpace'
            \ .' containedin=pythonComment,pythonString,pythonRawString'
unlet! s:e s:full s:ignore

highlight! def link jediIgnore Ignore
highlight! def link jediFatSymbol Ignore
highlight! def link jediSpace Normal

highlight! def link jediFunction Pmenu
highlight! def link jediFat TabLine
