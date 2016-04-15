let g:UltiSnipsSnippetsDir =
  \ g:vim_plug_dir . "/vim-snippets/UltiSnips/"

let g:UltiSnipsEnableSnipMate = 1
let g:UltiSnipsSnippetDirectories = [ "UltiSnips" ]

let g:UltiSnipsEditSplit = 'horizontal'

let g:UltiSnipsEnableSnipMate = 0

" let g:UltiSnipsUsePythonVersion = 3
let g:ultisnips_python_style = "google"

" Complete UltiSnip snippets with <TAB>/<S-TAB>
function! g:UltiSnips_JumpForward()
    if exists('*UltiSnips#JumpForwards')
      call UltiSnips#JumpForwards()
    endif
    if !exists('g:ulti_jump_forwards_res') || g:ulti_jump_forwards_res == 0
      return "\<TAB>"
    endif
    return ""
endfunction

function! g:UltiSnips_JumpBackward()
  if exists('*UltiSnips#JumpBackwards')
    call UltiSnips#JumpBackwards()
  endif
  if !exists('g:ulti_jump_backwards_res') || g:ulti_jump_backwards_res == 0
    return "\<S-TAB>"
  endif
  return ""
endfunction

let g:UltiSnipsExpandTrigger = "<s-cr>"

" do nothing if there is no snippet
inoremap <s-cr> <right><left>

let b:did_after_plugin_ultisnips_after = 1

augroup ultisnips_startup
  au InsertEnter * snoremap <expr> <TAB> g:UltiSnips_JumpForward()
  au InsertEnter * nnoremap <expr> <TAB> g:UltiSnips_JumpForward()
  au InsertEnter * snoremap <expr> <S-TAB> g:UltiSnips_JumpBackward()
  au InsertEnter * nnoremap <expr> <S-TAB> g:UltiSnips_JumpBackward()
  au InsertEnter * inoremap <expr> <TAB> pumvisible() ? "\<c-n>" : g:UltiSnips_JumpForward()
  au InsertEnter * inoremap <expr> <S-TAB> pumvisible() ? "\<c-p>" : g:UltiSnips_JumpBackward()
        \ | au! ultisnips_startup
augroup END
