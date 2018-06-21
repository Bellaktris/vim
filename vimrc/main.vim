" vim:filetype=vim:foldmethod=marker:foldmarker={{{,}}}:foldenable

if executable('curl') && !filereadable(g:root_dir . '/autoload/plug.vim')
    let s:vimplug_link='https://raw.githubusercontent.com/junegunn/'
                        \.'vim-plug/master/plug.vim'
    execute 'silent !curl -fLo '.g:root_dir
                \.'/autoload/plug.vim --create-dirs '.s:vimplug_link
endif

let g:largefile_trigger_size=0.5

if exists('t_8f')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
endif

if exists('t_8b')
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if (has('nvim') || v:version >= 742)
  if $TERM_PROGRAM == 'iTerm.app'
    set termguicolors
  else
    " mosh doesn't support true color yet...
    if $SSH_TTY != '' && !executable('xset')
      set notermguicolors
    else
      call system('xset q &>/dev/null')
      if v:shell_error == 0
        set termguicolors
      else
        set notermguicolors
      endif  " v:shell_error == 0
    endif  " $SSH_TTY == ''
  endif
endif  " (has('nvim') || v:version >= 742)

if has('nvim-0.2')
  set guicursor=
else
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
endif  " has('nvim-0.2')

" disable some default plugins
let g:loaded_2html_plugin     = 1
let g:loaded_netrw            = 1
let g:loaded_netrwPlugin      = 1
let g:loaded_getscriptPlugin  = 1
let g:loaded_logipat          = 1
let g:loaded_rrhelper         = 1
let g:loaded_vimballPlugin    = 1
let g:python_host_skip_check  = 1


call plug#begin(g:vim_plug_dir)

" Vim-Plug                                                                 {{{
  Plug 'https://github.com/junegunn/vim-plug',
      \ {'on': [], 'do': 'cp plug.vim ' . g:temp_dir}
" }}}

" Helpers                                                                  {{{
  Plug 'https://github.com/vim-scripts/cecutil'

  Plug 'https://github.com/tpope/vim-repeat'

  Plug 'https://github.com/google/vim-maktaba'

  " very strange bug...
  " Plug 'https://github.com/google/vim-glaive'

  Plug 'https://github.com/kana/vim-textobj-user'

  Plug 'https://github.com/Shougo/unite.vim'
" }}}

" Better motions                                                           {{{
  Plug 'https://github.com/kana/vim-textobj-indent'
  Plug 'https://github.com/jeetsukumaran/vim-indentwise'

  Plug 'https://github.com/coderifous/textobj-word-column.vim'

  Plug 'https://github.com/Julian/vim-textobj-brace'

  Plug 'https://github.com/chaoren/vim-wordmotion'

  Plug 'https://github.com/justinmk/vim-sneak'
  " Plug 'https://github.com/Bellaktris/quick-scope'

  Plug 'https://github.com/easymotion/vim-easymotion'

  Plug 'https://github.com/haya14busa/vim-easyoperator-line'
" }}}

" Fixes for vim strange behaviour                                          {{{
  Plug 'https://github.com/svermeulen/vim-easyclip'
  Plug 'https://github.com/Konfekt/vim-alias'

  Plug 'https://github.com/Konfekt/FastFold'
  Plug 'https://github.com/kopischke/vim-stay'

  Plug 'https://github.com/pgdouyon/vim-evanesco'

  Plug 'https://github.com/roxma/vim-tmux-clipboard'

  Plug 'https://github.com/haya14busa/incsearch.vim'
  Plug 'https://github.com/haya14busa/incsearch-fuzzy.vim'

  Plug 'https://github.com/powerman/vim-plugin-viewdoc',
    \ { 'on': ['ViewDocHelp', 'ViewDoc', 'ViewDocMan'] }

  Plug 'https://github.com/tpope/vim-dispatch',
        \ { 'on': ['Make', 'Dispatch'] }
  Plug 'https://github.com/radenling/vim-dispatch-neovim',
    \ { 'on': ['Make', 'Dispatch'] }

  au User vim-dispatch-neovim call DispatchAddNeovim()

  Plug 'https://github.com/romainl/vim-qf'

  if !executable('fwdproxy-config')
    let s:ycm_install = "'./install.py --clang-completer"
  else
    let s:ycm_install = "'http_proxy=http://fwdproxy:8080 "
    let s:ycm_install .= "https_proxy=http://fwdproxy:8080 "
    let s:ycm_install .= "./install.py --clang-completer"
  endif  " !executable('fwdproxy-config')

  if executable('rustc') | let s:ycm_install .= ' --racer-completer' | endif
  if executable('go') | let s:ycm_install .= ' --gocode-completer' | endif
  if executable('node') | let s:ycm_install .= ' --tern-completer' | endif

  if v:version >= 742
    execute "Plug 'https://github.com/Valloric/YouCompleteMe', "
      \. "{ 'do': " . s:ycm_install . "' }"

    Plug 'https://github.com/rdnetto/YCM-Generator',
      \ { 'on': 'YcmGenerateConfig', 'branch': 'stable' }

    augroup YCMAugroup | au!
      au VimEnter * call youcompleteme#Enable() | au! YCMAugroup
    augroup END
  endif
" }}}

" Utility                                                                  {{{
  Plug 'https://github.com/tweekmonster/startuptime.vim',
    \ { 'on': 'StartupTime' }

  Plug 'https://github.com/vim-scripts/Colour-Sampler-Pack',
    \ { 'on': 'COLORSCROLL' }
" }}}

" Appearance and syntax highlighting                                       {{{
  Plug 'https://github.com/mhinz/vim-startify'

  Plug 'https://github.com/mhinz/vim-hugefile'

  Plug 'https://github.com/chriskempson/base16-vim'

  Plug 'https://github.com/ap/vim-css-color',
    \{ 'for': ['css', 'scss', 'less'] }

  command! AddCSSColors call plug#load('vim-css-color')

  Plug 'https://github.com/luochen1990/rainbow',
    \ helpers#is_modern() ? {} : { 'on': [] }

  Plug 'https://github.com/sheerun/vim-polyglot'

  Plug 'https://github.com/othree/javascript-libraries-syntax.vim'

  Plug 'https://github.com/neovimhaskell/haskell-vim'

  Plug 'https://github.com/Bellaktris/vim-hack'

  Plug 'https://github.com/nelstrom/vim-markdown-folding'

  Plug 'https://github.com/goerz/ipynb_notedown.vim'

  Plug 'https://github.com/artoj/qmake-syntax-vim'

  Plug 'https://github.com/octol/vim-cpp-enhanced-highlight'

  Plug 'https://github.com/vim-scripts/google.vim',
    \ { 'for': ['cpp', 'c', 'objc', 'objcpp'],
    \   'do': 'mv indent/google.vim indent/cpp.vim' }

  Plug 'https://github.com/tpope/vim-sleuth'

  Plug 'https://github.com/vim-airline/vim-airline'
  Plug 'https://github.com/vim-airline/vim-airline-themes'
" }}}

" Fast scripting and making                                                {{{
  Plug 'https://github.com/Bellaktris/Bexec',
    \ {'on': 'Bexec'}

  Plug 'https://github.com/skywind3000/asyncrun.vim',
    \ {'on': 'AsyncRun'}

  Plug 'https://github.com/johnsyweb/vim-makeshift',
    \ {'on': 'Makeshift'}
" }}}

  " File system and code navigation                                          {{{
    Plug 'https://github.com/scrooloose/nerdtree',
      \ { 'on': ['NERDTreeToggle'] }
    Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin',
      \ { 'on': ['NERDTreeToggle'] }
    Plug 'https://github.com/dhruvasagar/vim-vinegar',
      \ { 'on': ['NERDTreeToggle'] }
    Plug 'https://github.com/Nopik/vim-nerdtree-direnter',
      \ { 'on': ['NERDTreeToggle'] }

    Plug 'https://github.com/Bellaktris/libview'

    Plug 'https://github.com/majutsushi/tagbar'

    Plug 'https://github.com/mhinz/vim-grepper',
    \ { 'on': 'Grepper' }

  Plug 'https://github.com/Olical/vim-enmasse',
    \ { 'on': 'EnMasse' }

  Plug 'https://github.com/junegunn/fzf',
    \ { 'dir': '~/.fzf',
    \   'do': './install --64 --key-bindings --completion --no-update-rc' }

  Plug 'https://github.com/junegunn/fzf.vim'

  Plug 'https://github.com/vim-scripts/a.vim'
" }}}

" Latex                                                                    {{{
  Plug 'https://github.com/lervag/vimtex',
    \ {'for': 'tex'}

  Plug 'https://github.com/KeitaNakamura/tex-conceal.vim',
    \ {'for': 'tex'}
" }}}

" Tmux integration                                                         {{{
  Plug 'https://github.com/christoomey/vim-tmux-navigator'
  Plug 'https://github.com/tmux-plugins/vim-tmux-focus-events'
" }}}

" Git integration                                                          {{{
  Plug 'https://github.com/tpope/vim-fugitive'
  Plug 'https://github.com/junegunn/gv.vim'
  Plug 'https://github.com/int3/vim-extradite'
" }}}

" More power for general editing                                           {{{
  Plug 'https://github.com/tpope/vim-surround'

  Plug 'https://github.com/Bellaktris/latex-unicoder.vim'

  Plug 'https://github.com/junegunn/vim-easy-align',
    \ { 'on': ['<Plug>(EasyAlign)'] }

  Plug 'https://github.com/Bellaktris/vis.vim',
    \ { 'on': ['B', 'S'] }
  Plug 'https://github.com/tommcdo/vim-exchange'

  Plug 'https://github.com/mtth/scratch.vim'

  Plug 'https://github.com/terryma/vim-multiple-cursors'
" }}}

" More power for code editing                                              {{{
  Plug 'https://github.com/tpope/vim-commentary'

  Plug 'https://github.com/tpope/vim-abolish'

  Plug 'https://github.com/lyuts/vim-rtags'

  Plug 'https://github.com/vim-scripts/UltiSnips',
    \ { 'on': [] }

  augroup ultisnips_startup | au!
    au InsertEnter * call plug#load('UltiSnips')
  augroup END

  Plug 'https://github.com/Bellaktris/vim-snippets'
" }}}

" IDE features {{{
" }}}

" Syntax checking                                                          {{{
  Plug 'https://github.com/benekastah/neomake',
    \ { 'on': 'Neomake' }
" }}}

" Miscelaneus                                                              {{{
  Plug 'https://github.com/csexton/trailertrash.vim'

  Plug 'https://github.com/Chiel92/vim-autoformat'

  Plug 'https://github.com/MarcWeber/vim-addon-local-vimrc'
" }}}

call plug#end()

let plugins = glob(expand('<sfile>:p:h') . '/plugin-options/*.vim')
for file in split(plugins, '\n') | execute 'source ' . file | endfor

silent! execute 'source ' . g:root_dir . '/vimrc/secret.vim'
