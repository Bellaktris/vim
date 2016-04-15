let g:netrw_localrmdir='rm -r'

let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '__pycache__',
                   \'\.git', '\.hg', '\.svn', '\.bzr']
let g:NERDTreeWinSize=35
let NERDTreeMinimalUI=0
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1

let NERDTreeMapOpenInTab='<ENTER>'

" let g:NERDTreeDirArrowExpandable = '📁'
" let g:NERDTreeDirArrowCollapsible = '📂'

let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

function! NerdTreeToggle()
  if &ft == 'nerdtree' && winnr('$') == 1
    return
  endif
  execute 'NERDTreeToggle '.expand('%:p:h')
endfunction

nmap <silent> <Plug>NerdTreeStart :call NerdTreeToggle()<cr>
