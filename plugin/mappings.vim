"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> Leader
"    -> General
"    -> Motion related
"    -> Appearance
"    -> Filesystem and code navigation
"    -> Fast scripting
"    -> General editing
"    -> Command line
"    -> Code editing
"    -> Spell checking
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Changes to vim's defaults
onoremap b vb
onoremap B vB

map 0 $

nnoremap - ^
xnoremap - ^
onoremap - v^

imap <c-p> <c-[>pa
imap <c-n> <c-[>ua

noremap <silent> <s-d> i<cr><c-[>

" Leader
let g:mapleader = ","
let g:maplocalleader = ","

" General
" function! BetterG()
"   call cursor('$', col('.'))
" endfunction

" function! Bettergg()
"   call cursor(1, col('.'))
" endfunction

" vnoremap <silent> gg :call Bettergg()<cr>
" vnoremap <silent> G :call BetterG()<cr>

function! AddlineAbove()
  silent! noautocmd execute "normal mzO \<Esc>\"_x`z"
endfunction

function! AddlineBelow()
  silent! noautocmd execute "normal mzo \<Esc>\"_x`z"
endfunction

noremap <silent> <s-cr> :call AddlineAbove()<cr>
noremap <silent> <cr>   :call AddlineBelow()<cr>

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

if &clipboard[:10] == 'unnamedplus'
    xnoremap <silent> <expr> p
          \ ':<c-u>silent! call EasyClip#Paste#PasteTextVisualMode(''+'',1)<cr>'
    xnoremap <silent> <expr> P
          \ ':<c-u>silent! call EasyClip#Paste#PasteTextVisualMode(''+'',1)<cr>'

    nnoremap <silent> s :<c-u>silent! call EasyClip#Substitute#OnPreSubstitute('+', 1)<cr>:silent! set opfunc=EasyClip#Substitute#SubstituteMotion<cr>g@

    nnoremap <silent> S :<c-u>silent! call EasyClip#Substitute#SubstituteLine('+', 1)<cr>:silent! call repeat#set("\<plug>SubstituteLine")<cr>
else
    if &clipboard[:6] == 'unnamed'
        xnoremap <silent> <expr> p
              \ ':<c-u>silent! call EasyClip#Paste#PasteTextVisualMode(''*'',1)<cr>'
        xnoremap <silent> <expr> P
              \ ':<c-u>silent! call EasyClip#Paste#PasteTextVisualMode(''*'',1)<cr>'

        nnoremap <silent> s :<c-u>silent! call EasyClip#Substitute#OnPreSubstitute('*', 1)<cr>:silent! set opfunc=EasyClip#Substitute#SubstituteMotion<cr>g@

        nnoremap <silent> S :<c-u>silent! call EasyClip#Substitute#SubstituteLine('*', 1)<cr>:silent! call repeat#set("\<plug>SubstituteLine")<cr>
    else
        xnoremap <silent> <expr> p
              \ ':<c-u>silent! call EasyClip#Paste#PasteTextVisualMode(''"'',1)<cr>'
        xnoremap <silent> <expr> P
              \ ':<c-u>silent! call EasyClip#Paste#PasteTextVisualMode(''"'',1)<cr>'

        nnoremap <silent> s :<c-u>silent! call EasyClip#Substitute#OnPreSubstitute('"', 1)<cr>:silent! set opfunc=EasyClip#Substitute#SubstituteMotion<cr>g@

        nnoremap <silent> S :<c-u>silent! call EasyClip#Substitute#SubstituteLine('"', 1)<cr>:silent! call repeat#set("\<plug>SubstituteLine")<cr>
    endif
endif

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


" Appearance
noremap <silent> <leader>za :set foldenable!<cr>
noremap <silent> <leader>cc :let &colorcolumn = g:colorcolumn - &colorcolumn<cr>


" Filesystem and code navigation
nmap <leader>jp g]

nmap <leader>nt <plug>NerdTreeStart
noremap <silent> <leader>tb :let g:tagbar_width=helpers#free_hspace()<cr>:TagbarToggle<cr>

nmap <silent> <leader>gt :Windows<cr>
nmap <silent> <leader>cp :call helpers#call_from_git_root('FZF')<cr>

if executable('rg') || executable('ag')
  let g:grep_opts = ''
elseif executable('git')
  let g:grep_opts = '-F'
elseif executable('ack')
  let g:grep_opts = '-Q'
else
  let g:grep_opts = ''
endif

xmap <silent> <leader>ag y:call FastGrepFirstRoot(substitute(@0, '--', '', 'g'), g:grep_opts)<cr>
xmap <silent> <leader>gp y:call FastGrepLastRoot(substitute(@0, '--', '', 'g'), g:grep_opts)<cr>

exec "nmap <leader>ag :FastGrepU "
exec "nmap <leader>gp :FastGrepL "

nnoremap <silent> <leader>en :call EnMasse()<cr>

noremap <leader>cd :cd %:p:h<cr>:pwd<cr>
noremap <silent> <leader>te :call helpers#call_from_last_root_dir('FZF')<cr>

" Fast scripting and ide-like features
nmap <leader>xx <plug>(execute-file)
nmap <leader>vx <plug>(view-file)
nmap <leader>le <plug>(view-compilation-status)

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

let g:state="code"
function! ChangeState()
  let a:cursor_pos = getpos(".")
  if !exists(':LLmode')
      exec "normal :LLsession new\<cr>"
  else
    if g:state=="code"
      exec "normal :LLmode debug\<cr>"
      let g:state="debug"
    else
      let g:state="code"
      exec "normal :LLmode code\<cr>"
    endif
  endif
  exec cursor(a:cursor_pos[1], a:cursor_pos[2])
endfunction
nmap <silent> <leader>dd :call ChangeState()<cr>

nmap <leader>bp <Plug>LLBreakSwitch

nnoremap <silent> <leader>pt :LL print <C-R>=expand('<cword>')<CR><CR>
vnoremap <silent> <leader>pt :<C-U>LL print <C-R>=lldb#util#get_selection()<CR><CR>

nmap <silent> <M-cr> :LL continue<cr>
nmap <silent> <M-j> :LL next<cr>
nmap <silent> <M-l> :LL step<cr>
nmap <silent> <M-k> :LL reverse-next<cr>
nmap <silent> <M-h> :LL finish<cr>


" General editing
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

" Spell checking
noremap <silent> <leader>ss :setlocal spell!<cr>

noremap <leader>sn [s
noremap <leader>sp [s
noremap <leader>sa zg
