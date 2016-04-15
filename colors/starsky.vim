function! s:SourceColorscheme(clrscheme)
   for path in split(&runtimepath, ',')
     let colorscheme_name = path . '/colors/' . a:clrscheme . '.vim'
     if filereadable(colorscheme_name)
       execute 'source ' . colorscheme_name
     endif
   endfor
endfunction

if has('gui') || exists('&termguicolors')
            \ && &termguicolors == 1
  call s:SourceColorscheme('slate')
else
  call s:SourceColorscheme('lucius')
endif

let g:colors_name = 'starsky'

highlight! Visual cterm=reverse ctermbg=242 guifg=khaki guibg=olivedrab

highlight! Normal guibg=NONE guifg=White ctermfg=White ctermbg=NONE
highlight! PreProc guifg=orange ctermfg=red guibg=NONE ctermbg=NONE
highlight! Comment guifg=gray40 ctermfg=59  guibg=NONE ctermbg=NONE
highlight! CursorLineNr guibg=NONE ctermbg=NONE guifg=yellow ctermfg=yellow

highlight! Conceal cterm=NONE ctermbg=NONE ctermfg=white guibg=NONE guifg=white

highlight! DiffDelete gui=NONE guifg=#000001 guibg=NONE
highlight! DiffText   gui=bold guifg=#000001 guibg=#446707
highlight! DiffAdd    gui=NONE guifg=#000001 guibg=#AACD5D
highlight! DiffChange gui=NONE guifg=#000001 guibg=#AACD5D

highlight! SignifySignDelete gui=NONE guifg=fg guibg=NONE
highlight! SignifySignAdd    gui=NONE guifg=fg guibg=NONE guifg=#AACD5D
highlight! SignifySignChange gui=NONE guifg=fg guibg=NONE

if has('nvim')
  let g:terminal_background = "#000000"
  let g:terminal_foreground = "#ffffff"
  let g:terminal_color_0    = "#000000"
  let g:terminal_color_1    = "#c70000"
  let g:terminal_color_2    = "#18b218"
  let g:terminal_color_3    = "#b26818"
  let g:terminal_color_4    = "#36b4bf"
  let g:terminal_color_5    = "#b218b2"
  let g:terminal_color_6    = "#18b2b2"
  let g:terminal_color_7    = "#b2b2b2"
  let g:terminal_color_8    = "#ffffff"
  let g:terminal_color_9    = "#ff5454"
  let g:terminal_color_10   = "#54ff54"
  let g:terminal_color_11   = "#ffff54"
  let g:terminal_color_12   = "#d0d0ff"
  let g:terminal_color_13   = "#ff54ff"
  let g:terminal_color_14   = "#54ffff"
  let g:terminal_color_15   = "#ffffff"
endif

highlight! FoldColumn ctermbg=black ctermfg=black
highlight! FoldColumn guibg=black guifg=black

highlight! ColorColumn guibg=#444444 ctermbg=gray

highlight! lCursor guifg=NONE guibg=Cyan

highlight! Pmenu term=bold cterm=bold ctermfg=0 ctermbg=gray
highlight! Pmenu gui=bold guifg=#ffa64d guibg=DimGray

highlight! SignColumn ctermbg=NONE guibg=NONE
highlight! LineNr ctermbg=NONE guibg=NONE

highlight! link NeomakeErrorSign    SyntasticErrorSign
highlight! link NeomakeInfoSign     SyntasticStyleErrorSign

highlight! link NeomakeWarningSign  SyntasticWarningSign
highlight! link NeomakeMessageSign  SyntasticStyleWarningSign

highlight! link NeomakeError    SyntasticErrorLine
highlight! link NeomakeInfo     SyntasticStyleErrorLine

highlight! link NeomakeWarning  SyntasticWarningLine
highlight! link NeomakeMessage  SyntasticStyleWarningLine

highlight! SyntasticWarning gui=NONE cterm=NONE
highlight! SyntasticError gui=NONE cterm=NONE

highlight! SyntasticErrorSign ctermbg=NONE ctermfg=red guibg=NONE guifg=red

highlight! SyntasticWarningSign ctermbg=NONE ctermfg=yellow
highlight! SyntasticWarningSign  guibg=NONE guifg=darkkhaki

highlight! SyntasticErrorLine   ctermbg=darkred cterm=NONE
highlight! SyntasticErrorLine   guibg=darkred gui=NONE

highlight! SyntasticWarningLine ctermbg=darkyellow cterm=NONE
highlight! SyntasticWarningLine guibg=darkyellow gui=NONE

highlight! YcmErrorLine   ctermbg=NONE cterm=NONE
highlight! YcmWarningLine ctermbg=NONE cterm=NONE

highlight! link SyntasticStyleErrorLine SyntasticWarningLine
highlight! link SyntasticStyleWarningLine SyntasticWarningLine

highlight! SyntasticStyleErrorSign ctermbg=NONE ctermfg=gray
highlight! SyntasticStyleErrorSign guibg=NONE guifg=aquamarine

highlight! link SyntasticStyleWarningSign SyntasticStyleErrorSign

highlight! VertSplit ctermbg=NONE guibg=NONE gui=NONE cterm=NONE term=NONE
highlight! NonText guifg=#404040 guibg=NONE

highlight! CursorLine cterm=NONE gui=NONE guibg=NONE ctermbg=NONE
highlight! jediFunction guibg=gray40 ctermbg=gray
