" Folding
set nofoldenable
set foldmethod=manual

" External vimrc's
set secure
set exrc

" Persistent undo
exec 'set undodir=' . g:temp_dir . '/undodir'
set undofile


" :tmpfile
command! Tmpfile :exec 'tabedit ' . g:temp_dir . '/tmpfile'

if !filereadable(g:temp_dir . '/tmpfile')
    execute 'silent !touch ' . g:temp_dir . '/tmpfile'
endif

if exists(':Alias')
  call Alias(0, 'tmpfile', 'Tmpfile')
endif

" Autoclose helper windows
function! TestIfOnlyWindow()
  if &ft == 'qf' | let b:autoclose = 1 | endif
  if winnr('$') == 1 && exists('b:autoclose')
        \ && b:autoclose == 1 | quit | endif
endfunction

augroup onlywindow | au!
  au WinEnter * call TestIfOnlyWindow()
augroup END


" XTabedit
command! -nargs=1 XTabedit call helpers#open_new_or_existing(<f-args>)


" Clipboard
if has('nvim') || $SSH_TTY == ''
  set clipboard=unnamed,unnamedplus
else
  set clipboard=
endif

" OSC 52: propagate yanks to local clipboard over SSH (vim only;
" neovim uses its built-in OSC 52 provider automatically)
if !has('nvim') && $SSH_TTY != ''
  function! s:Osc52Yank()
    let text = join(v:event.regcontents, "\n")
    let encoded = system('base64 | tr -d "\n"', text)
    call writefile(["\x1b]52;c;" . encoded . "\x07"], '/dev/tty', 'b')
  endfunction

  augroup osc52_yank | au!
    autocmd TextYankPost * call s:Osc52Yank()
  augroup END
endif

" File types and paths
set ffs=unix,dos,mac
set path+=~/c++/include,~/fbsource/fbcode


" Wildignore
set wildignore=*.o,*~,*.pyc
if has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif


" Formatter
if executable("par")
    set formatprg=par\ -s0w79rj
endif


" Restore cursor on open
augroup vimrcs_settings | au!
    au BufReadPost *
         \ if helpers#is_small()
          \&& line("'\"") > 0
          \&& line("'\"") <= line("$")
        \|   exe "normal! g`\""
        \| endif

  " Trim trailing whitespace on save
  au BufWrite * if &modified && exists(':TrailerTrim') | TrailerTrim | endif

  " Make file executable if it contains shebang
  au BufWritePost * call MakeExecutable()
augroup END

function! MakeExecutable()
  if getline(1) =~ "^#!"
    call system('chmod +x ' . shellescape(expand('%:p')))
  endif
endfunction


" Options
set nobackup
set shortmess=filnxtToOFca
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

if exists('&langremap')
  set nolangremap
endif

if exists('&inccommand')
  set inccommand=split
endif

if !has('nvim')
    execute 'set viminfo+=n'.g:temp_dir.'/viminfo'
else
    execute 'set viminfo+=n'.g:temp_dir.'/nviminfo'
endif
