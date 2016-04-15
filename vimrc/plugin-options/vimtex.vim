let g:polyglot_disabled = ['latex']

let g:vimtex_imaps_enabled = 0
let g:vimtex_indent_enabled = 0
let g:vimtex_indent_bib_enabled = 0
let g:vimtex_mappings_enabled = 0

let g:vimtex_toc_show_preamble = 0
let g:vimtex_toc_show_numbers = 0

let g:tex_flavor = "latex"

let g:vimtex_compiler_latexmk = {
  \ 'background' : 1,
  \ 'build_dir' : 'build',
  \ 'callback' : 0,
  \ 'continuous' : 0,
  \ 'options' : [
  \   '-pdf',
  \   '-verbose',
  \   '-file-line-error',
  \   '-shell-escape',
  \   '-synctex=1',
  \   '-interaction=nonstopmode',
  \ ],
\}

let g:vimtex_syntax_minted = [
  \ {
  \   'lang' : 'c',
  \ },
  \ {
  \   'lang' : 'cpp',
  \   'environments' : ['cppcode', 'cppcode_test'],
  \ },
  \ {
  \   'lang' : 'python',
  \   'ignore' : [
  \     'pythonEscape',
  \     'pythonBEscape',
  \     ],
  \ }
\]

if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers =  {
    \   'c' : ['->', '.'],
    \   'ocaml' : ['.', '#'],
    \   'cpp,objcpp' : ['->', '.', '::'],
    \   'perl' : ['->'],
    \   'php' : ['->', '::'],
    \   'ruby' : ['.', '::'],
    \   'lua' : ['.', ':'],
    \   'erlang' : [':'],
    \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
    \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
    \             're!\[.*\]\s'],
    \ }
endif

let g:ycm_semantic_triggers.tex = [
  \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
  \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
  \ 're!\\hyperref\[[^]]*',
  \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
  \ 're!\\(include(only)?|input){[^}]*',
  \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
  \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
  \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
\ ]

if executable('okular')
  let g:vimtex_view_general_viewer = 'okular'
  let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
  let g:vimtex_view_general_options_latexmk = '--unique'
endif

let g:vimtex_view_automatic = 0

let g:vimtex_quickfix_warnings =
  \ { 'default' : 1, 'underfull' : 0, 'overfull' : 0 }
