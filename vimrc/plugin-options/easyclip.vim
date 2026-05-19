if has('nvim') || $SSH_TTY == ''
  let &clipboard="unnamed"
else
  let &clipboard=""
endif

let g:EasyClipUseYankDefaults = 0
let g:EasyClipUseCutDefaults = 0
let g:EasyClipEnableBlackHoleRedirect = 0
let g:EasyClipUseSubstituteDefaults = 0
let g:EasyClipUsePasteToggleDefaults = 0
let g:EasyClipUsePasteDefaults = 0
let g:EasyClipAutoFormat = 0
