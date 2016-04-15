"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> enable filetype plugins
"    -> set folding
"    -> extern vimrc's
"    -> persistent undo
"    -> qf windows
"    -> define xtabedit
"    -> [Command Lines]
"    -> clipboard copy/paste
"    -> remove the Windows ^M - when the encodings gets messed up
"    -> wildignore
"    -> use Unix as the standard file type
"    -> set numbers
"    -> set par as vim formatter
"    -> set . to always work via normal mode
"    -> visual @
"    -> treat long lines as break lines
"    -> reasonable mappings to open paths
"    -> reasonable mappings to move between windows
"    -> remember info about open buffers on close
"    -> remember info about open buffers on close
"    -> delete trailing white space on save,
"    -> neovim defaults
"    -> neovim reasonable mappings
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" disable folding by default
" set foldminlines=10
set nofoldenable
set foldmethod=manual

" extern vimrc's
set secure
set exrc

" persistent undo
exec 'set undodir=' . g:temp_dir . '/undodir'
set undofile


" :tmpfile
command! Tmpfile :exec 'tabedit ' . g:temp_dir . '/tmpfile'

if !filereadable(g:temp_dir . '/tmpfile')
    execute 'silent !touch ' . g:temp_dir . '/tmpfile'
endif

if exists(':Alias')
  Alias tmpfile Tmpfile
endif

" autoclose helper windows
function! TestIfOnlyWindow()
  if &ft == 'qf' | let b:autoclose = 1 | endif
  if winnr('$') == 1 && exists('b:autoclose')
        \ && b:autoclose == 1 | quit | endif
endfunction

augroup onlywindow | au!
  au WinEnter * call TestIfOnlyWindow()
augroup END


" qf windows
" augroup qf | au!
"   au QuickFixCmdPost l*    lwindow
"   au VimEnter         *    cwindow
"   au QuickFixCmdPost [^l]* cwindow
" augroup END


" define xtabedit
command! -nargs=1 XTabedit call helpers#open_new_or_existing(<f-args>)


" [Command lines]
augroup command_line | au!
  au CmdWinEnter * nnoremap <buffer> <s-cr> <cr>

  au CmdWinEnter * nnoremap <buffer> <cr>   <cr>
  au CmdWinEnter * nnoremap <buffer> <c-[> <c-c>
augroup END


" clipboard copy/paste
set clipboard=unnamed,unnamedplus


" use Unix as the standard file type
set ffs=unix,dos,mac
set path+=~/c++/include,~/fbsource/fbcode


" wildignore
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif


" set par as vim formatter
if executable("par")
    set formatprg=par\ -s0w79rj
endif


" set . to always work via normal mode
xnoremap <silent> . :normal .<cr>


" visual @
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

xnoremap <silent> @ :<C-u>call ExecuteMacroOverVisualRange()<cr>


" treat long lines as break lines
" (useful when moving around in them)
map j gj
map k gk


" reasonable mappings to open paths
nnoremap <c-w>gf gf
nnoremap gf <c-w>gf

" reasonable mappings to move between windows
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

inoremap <silent> <c-h> <c-[>:TmuxNavigateLeft<cr>
inoremap <silent> <c-j> <c-[>:TmuxNavigateDown<cr>
inoremap <silent> <c-k> <c-[>:TmuxNavigateUp<cr>
inoremap <silent> <c-l> <c-[>:TmuxNavigateRight<cr>


" remember info about open buffers on close
augroup vimrcs_settings_defaults
    au! BufReadPost *
         \ if helpers#is_small()
          \&& line("'\"") > 0
          \&& line("'\"") <= line("$")
        \|   exe "normal! g`\""
        \| endif
augroup END


" delete trailing white space on save,
" useful for Python and CoffeeScript ;)
augroup vimrcs_settings_defaults
  au BufWrite * if &modified && exists(':TrailerTrim') | TrailerTrim | endif
augroup END


" make file executable if it contains shebang
function! MakeExecutable()
  if getline(1) =~ "^#!"
    silent !chmod +x %
  endif
endfunction

augroup vimrcs_settings_defaults
  au BufWritePost * call MakeExecutable()
augroup END


" sudo write
cmap w! w !sudo tee % >/dev/null


" neovim defaults
set nobackup
set shortmess=a
set nowritebackup
set noswapfile
set lazyredraw
set hidden
set showmatch
set mat=2
set diffopt+=vertical
set noerrorbells
set visualbell
set t_vb=
set autoindent
set nosmartindent
set nocindent
set ignorecase
set smartcase
set autoread
set virtualedit=onemore
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set complete-=i
set completeopt-=preview
set display=lastline
set formatoptions=tcqj
set history=10000
set splitright
set hlsearch
set incsearch
set nomagic
set langnoremap
set laststatus=2
set mouse=n
set nrformats=hex
set sessionoptions-=options
set smarttab
set tabpagemax=50
set tags=./tags;,tags
set ttyfast
set viminfo+=!
set viminfo^=%
set wildmenu
set expandtab
set switchbuf+=usetab,newtab
set textwidth=0
set tabstop=2
set shiftwidth=2
set nowrap
set nolinebreak
set viewoptions=cursor,folds,slash,unix

if exists('&inccommand')
  set inccommand=split
endif

if !has('nvim')
    execute 'set viminfo+=n'.g:temp_dir.'/viminfo'
else
    execute 'set viminfo+=n'.g:temp_dir.'/nviminfo'
endif


" neovim reasonable mappings
if !exists('$NVIM_TUI_ENABLE_TRUE_COLOR')
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if has('nvim')
    tnoremap <C-w>h <C-\><C-n><C-w>h
    tnoremap <C-w>j <C-\><C-n><C-w>j
    tnoremap <C-w>k <C-\><C-n><C-w>k
    tnoremap <C-w>l <C-\><C-n><C-w>l

    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
endif

