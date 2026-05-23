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

highlight! Visual ctermfg=NONE ctermbg=242 guifg=khaki guibg=olivedrab

highlight! Normal       ctermfg=White  ctermbg=NONE guifg=White  guibg=NONE
highlight! PreProc      ctermfg=red    ctermbg=NONE guifg=orange guibg=NONE
highlight! Comment      ctermfg=59     ctermbg=NONE guifg=gray40 guibg=NONE
highlight! CursorLineNr ctermfg=yellow ctermbg=NONE guifg=yellow guibg=NONE

highlight! Conceal cterm=NONE ctermfg=white ctermbg=NONE gui=NONE guifg=white guibg=NONE

highlight! DiffDelete gui=NONE guifg=#000000 guibg=NONE
highlight! DiffText   gui=bold guifg=#000000 guibg=#446707
highlight! DiffAdd    gui=NONE guifg=#000000 guibg=#AACD5D
highlight! DiffChange gui=NONE guifg=#000000 guibg=#AACD5D

highlight! SignifySignDelete gui=NONE guifg=fg       guibg=NONE
highlight! SignifySignAdd    gui=NONE guifg=#AACD5D guibg=NONE
highlight! SignifySignChange gui=NONE guifg=fg       guibg=NONE

if has('nvim')
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

highlight! FoldColumn ctermfg=black ctermbg=black guifg=black guibg=black

highlight! ColorColumn ctermbg=gray guibg=#444444

highlight! lCursor guifg=NONE guibg=Cyan

highlight! Pmenu term=bold cterm=bold ctermfg=215 ctermbg=240 gui=bold guifg=#ffa64d guibg=DimGray

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

highlight! SyntasticWarningSign ctermfg=yellow     ctermbg=NONE     guifg=darkkhaki  guibg=NONE

highlight! SyntasticErrorLine   cterm=NONE ctermbg=darkred    gui=NONE guibg=darkred
highlight! SyntasticWarningLine cterm=NONE ctermbg=darkyellow gui=NONE guibg=darkyellow

highlight! YcmErrorLine   cterm=NONE ctermbg=NONE
highlight! YcmWarningLine cterm=NONE ctermbg=NONE

highlight! link SyntasticStyleErrorLine SyntasticWarningLine
highlight! link SyntasticStyleWarningLine SyntasticWarningLine

highlight! SyntasticStyleErrorSign ctermfg=cyan ctermbg=NONE guifg=aquamarine guibg=NONE

highlight! link SyntasticStyleWarningSign SyntasticStyleErrorSign

" --- nvim diagnostics (vim.diagnostic API) ----------------------------------
" Modern LSP/diagnostic plumbing. The Syntastic*/Neomake*/Ycm* groups above
" stay for legacy code paths; these mirror their colors so the palette is
" consistent regardless of which subsystem reports an issue.

highlight! link DiagnosticError SyntasticErrorSign
highlight! link DiagnosticWarn  SyntasticWarningSign
highlight! link DiagnosticInfo  SyntasticStyleErrorSign
highlight! link DiagnosticHint  SyntasticStyleErrorSign
highlight! DiagnosticOk ctermfg=green guifg=#AACD5D

highlight! link DiagnosticSignError DiagnosticError
highlight! link DiagnosticSignWarn  DiagnosticWarn
highlight! link DiagnosticSignInfo  DiagnosticInfo
highlight! link DiagnosticSignHint  DiagnosticHint
highlight! link DiagnosticSignOk    DiagnosticOk

highlight! link DiagnosticVirtualTextError DiagnosticError
highlight! link DiagnosticVirtualTextWarn  DiagnosticWarn
highlight! link DiagnosticVirtualTextInfo  DiagnosticInfo
highlight! link DiagnosticVirtualTextHint  DiagnosticHint

highlight! DiagnosticUnderlineError cterm=undercurl gui=undercurl guisp=red
highlight! DiagnosticUnderlineWarn  cterm=undercurl gui=undercurl guisp=darkkhaki
highlight! DiagnosticUnderlineInfo  cterm=undercurl gui=undercurl guisp=aquamarine
highlight! DiagnosticUnderlineHint  cterm=undercurl gui=undercurl guisp=aquamarine

highlight! link DiagnosticFloatingError DiagnosticError
highlight! link DiagnosticFloatingWarn  DiagnosticWarn
highlight! link DiagnosticFloatingInfo  DiagnosticInfo
highlight! link DiagnosticFloatingHint  DiagnosticHint

" --- LSP semantic tokens (nvim 0.9+) ----------------------------------------
" Per-symbol coloring from the LSP server. By default everything here links
" to Identifier; these overrides give parameters, namespaces, properties etc.
" visual distinction beyond what tree-sitter alone can determine.

highlight! @lsp.type.parameter  guifg=#d0c0a0 ctermfg=180
highlight! @lsp.type.namespace  guifg=#c4a8e0 ctermfg=183
highlight! @lsp.type.property   guifg=#e0d090 ctermfg=222
highlight! @lsp.type.enumMember guifg=#e0d090 ctermfg=222

highlight! link @lsp.type.decorator     PreProc
highlight! link @lsp.type.macro         PreProc
highlight! link @lsp.type.typeParameter Type
highlight! link @lsp.type.class         Type
highlight! link @lsp.type.interface     Type
highlight! link @lsp.type.struct        Type
highlight! link @lsp.type.enum          Type

highlight! @lsp.mod.readonly        gui=italic cterm=italic
highlight! @lsp.mod.deprecated      gui=strikethrough cterm=strikethrough
highlight! link @lsp.mod.defaultLibrary Special

" --- Tree-sitter capture refinements ----------------------------------------
" Most @* groups already link sensibly via nvim's runtime defaults; these are
" the overrides where the visual gain is worth it. Route to @lsp.* defs above
" so tree-sitter and LSP highlights stay in sync.

highlight! link @variable.parameter @lsp.type.parameter
highlight! link @variable.member    @lsp.type.property
highlight! link @variable.builtin   Special

highlight! link @punctuation.bracket   NonText
highlight! link @punctuation.delimiter NonText

highlight! link @keyword.return    Keyword
highlight! link @keyword.import    Include
highlight! link @keyword.exception Exception

highlight! link @function.builtin Special
highlight! link @type.builtin     Type
highlight! link @constant.builtin Special

highlight! @comment.warning cterm=bold ctermfg=yellow gui=bold guifg=darkkhaki
highlight! @comment.error   cterm=bold ctermfg=red    gui=bold guifg=red

" --- nvim float windows / messages / terminal cursor ------------------------

highlight! link NormalFloat Normal
highlight! link FloatBorder NonText
highlight! link FloatTitle  PreProc
highlight! link FloatFooter NonText
highlight! link MsgArea     Normal
highlight! TermCursor cterm=reverse gui=reverse

" --- nvim LSP UI groups -----------------------------------------------------
" References under cursor get a subtle bg highlight (matches ColorColumn);
" inlay hints render dim+italic so they read as overlay text; the active
" parameter in signature help stands out with bold+underline.

highlight! link LspReferenceText  ColorColumn
highlight! link LspReferenceRead  LspReferenceText
highlight! link LspReferenceWrite LspReferenceText

highlight! LspInlayHint cterm=italic ctermfg=59 ctermbg=NONE gui=italic guifg=gray40 guibg=NONE
highlight! LspSignatureActiveParameter cterm=bold,underline gui=bold,underline

highlight! VertSplit ctermbg=NONE guibg=NONE gui=NONE cterm=NONE term=NONE
highlight! link WinSeparator VertSplit
highlight! NonText guifg=#404040 guibg=NONE

highlight! CursorLine cterm=NONE gui=NONE guibg=NONE ctermbg=NONE
highlight! jediFunction guibg=gray40 ctermbg=gray
