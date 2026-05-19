" Leader
let g:mapleader = ","
let g:maplocalleader = ","


" Vim default overrides
onoremap b vb
onoremap B vB

map 0 $

nnoremap - ^
xnoremap - ^
onoremap - v^

imap <c-p> <c-[>pa
imap <c-n> <c-[>ua

noremap <silent> <s-d> i<cr><c-[>

xnoremap <silent> . :normal .<cr>

map j gj
map k gk

nnoremap <c-w>gf gf
nnoremap gf <c-w>gf

cmap w! w !sudo tee % >/dev/null


" Visual @ (execute macro over visual range)
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

xnoremap <silent> @ :<C-u>call ExecuteMacroOverVisualRange()<cr>


" Add blank lines
function! AddlineAbove()
  silent! noautocmd execute "normal mzO \<Esc>\"_x`z"
endfunction

function! AddlineBelow()
  silent! noautocmd execute "normal mzo \<Esc>\"_x`z"
endfunction

noremap <silent> <s-cr> :call AddlineAbove()<cr>
noremap <silent> <cr>   :call AddlineBelow()<cr>


" Add spaces around visual selection
function! AddSpacesAround() range
    let l:firstpos = getpos("'<")
    let l:lastpos  = getpos("'>")

    call cursor(l:firstpos[1], l:firstpos[2])
    noautocmd execute "normal i \<Esc>"

    call cursor(l:lastpos[1], l:lastpos[2] + 1)
    noautocmd execute "normal a \<Esc>"
endfunction

vnoremap <silent> <s-space> :<c-u>call AddSpacesAround()<cr>
noremap <silent> <s-space> v:<c-u>call AddSpacesAround()<cr>


" EasyClip paste/substitute (clipboard-aware)
let s:reg = &clipboard =~# 'unnamedplus' ? '+' : &clipboard =~# 'unnamed' ? '*' : '"'

execute "xnoremap <silent> <expr> p ':<c-u>silent! call EasyClip#Paste#PasteTextVisualMode(''".s:reg."'',1)<cr>'"
execute "xnoremap <silent> <expr> P ':<c-u>silent! call EasyClip#Paste#PasteTextVisualMode(''".s:reg."'',1)<cr>'"
execute "nnoremap <silent> s :<c-u>silent! call EasyClip#Substitute#OnPreSubstitute('".s:reg."', 1)<cr>:silent! set opfunc=EasyClip#Substitute#SubstituteMotion<cr>g@"
execute "nnoremap <silent> S :<c-u>silent! call EasyClip#Substitute#SubstituteLine('".s:reg."', 1)<cr>:silent! call repeat#set(\"\\<plug>SubstituteLine\")<cr>"

nmap <c-n> <plug>EasyClipSwapPasteForward
nmap <c-p> <plug>EasyClipSwapPasteBackwards

nmap yc <Plug>(Exchange)
xmap X <Plug>(Exchange)
nmap ycc <Plug>(ExchangeClear)
nmap ycs <Plug>(ExchangeLine)

nmap d<leader>l <plug>(easyoperator-line-delete)
nmap y<leader>l <plug>(easyoperator-line-yank)
nmap c<leader>l <plug>(easyoperator-line-cut)
nmap s<leader>l <plug>(easyoperator-line-substitute)

omap <leader>l  <plug>(easyoperator-line-select)
xmap <leader>l  <plug>(easyoperator-line-select)


" Appearance toggles
noremap <silent> <leader>za :set foldenable!<cr>
noremap <silent> <leader>cc :let &colorcolumn = g:colorcolumn - &colorcolumn<cr>


" Navigation
nmap <silent> <leader>jp :call JumpToDefinition()<cr>

nmap <leader>nt <plug>NerdTreeStart
noremap <silent> <leader>tb :let g:tagbar_width=helpers#free_hspace()<cr>:TagbarToggle<cr>

nmap <silent> <leader>gt :Windows<cr>
nmap <silent> <leader>cp :call helpers#call_from_git_root('FZF')<cr>

nnoremap <silent> <leader>en :call EnMasse()<cr>

noremap <leader>cd :cd %:p:h<cr>:pwd<cr>
noremap <silent> <leader>te :call helpers#call_from_last_root_dir('FZF')<cr>


" Window navigation (tmux-aware)
for [s:key, s:dir] in [['h','Left'], ['j','Down'], ['k','Up'], ['l','Right']]
  execute 'nnoremap <silent> <c-'.s:key.'> :TmuxNavigate'.s:dir.'<cr>'
  execute 'inoremap <silent> <c-'.s:key.'> <c-[>:TmuxNavigate'.s:dir.'<cr>'
  if has('nvim')
    execute 'tnoremap <C-w>'.s:key.' <C-\><C-n><C-w>'.s:key
    execute 'tnoremap <C-'.s:key.'> <C-\><C-n><C-w>'.s:key
  endif
endfor


" IDE: execute/view
nmap <leader>xx <plug>(execute-file)
nmap <leader>vx <plug>(view-file)
nmap <leader>le <plug>(view-compilation-status)

" IDE: python/shell split
if empty($TMUX)
  noremap <silent> <leader>ip :execute helpers#free_hspace()
        \ . 'vsplit term://ptipython3'<cr>

  execute 'noremap <silent> <leader>sh :execute helpers#free_hspace() ' .
        \'. "vsplit term://" . &shell<cr>'
else
  noremap <silent> <leader>ip :call system(
        \ 'tmux split -h -l ' . helpers#free_hspace() . ' ptipython3')<cr>

  noremap <silent> <leader>sh :call system(
        \ 'tmux split -h -l ' . helpers#free_hspace())<cr>
endif


" Editing
xmap <leader>ga <plug>(EasyAlign)
nmap <leader>ga <plug>(EasyAlign)

noremap <leader>va ggVG

inoremap <silent> <leader>lt <esc>:call unicoder#start(1)<cr>
vnoremap <silent> <leader>lt :<c-u>call unicoder#selection()<cr>

noremap <silent> <leader>ux mmHmt:%s/<c-V><cr>//ge<cr>:retab<cr>'tzt'm

if has("mac") || has("macunix")
    nnoremap <d-j> <m-j>
    nnoremap <d-k> <m-k>
    vnoremap <d-j> <m-j>
    vnoremap <d-k> <m-k>
endif

nmap <leader>gs <plug>(scratch-insert-reuse)
nmap <leader>gS <plug>(scratch-insert-clear)
xmap <leader>gs <plug>(scratch-selection-reuse)
xmap <leader>gS <plug>(scratch-selection-clear)


" Command line
cmap <c-p> <up>
cmap <c-n> <down>

cnoremap <s-cr> <c-f>
cnoremap <silent> <c-r> History:<cr>

augroup command_line | au!
  au CmdWinEnter * nnoremap <buffer> <s-cr> <cr>
  au CmdWinEnter * nnoremap <buffer> <cr>   <cr>
  au CmdWinEnter * nnoremap <buffer> <c-[> <c-c>
augroup END


" Spell checking
noremap <silent> <leader>ss :setlocal spell!<cr>

noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
