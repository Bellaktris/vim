" vim:filetype=vim:foldmethod=marker:foldmarker={{{,}}}:foldenable

if executable('curl') && !filereadable(g:root_dir . '/autoload/plug.vim')
    let s:vimplug_link='https://raw.githubusercontent.com/junegunn/'
                        \.'vim-plug/master/plug.vim'
    execute 'silent !curl -fLo '.g:root_dir
                \.'/autoload/plug.vim --create-dirs '.s:vimplug_link
endif

let g:largefile_trigger_size=0.5

if exists('+t_8f')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
endif

if exists('+t_8b')
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set termguicolors

if has('nvim')
  set guicursor=
endif

" disable some default plugins
let g:loaded_2html_plugin     = 1
let g:loaded_netrw            = 1
let g:loaded_netrwPlugin      = 1
let g:loaded_getscriptPlugin  = 1
let g:loaded_logipat          = 1
let g:loaded_rrhelper         = 1
let g:loaded_vimballPlugin    = 1
let g:python3_host_skip_check = 1


call plug#begin(g:vim_plug_dir)

" Vim-Plug                                                                 {{{
  let g:plug_window="topleft"
  Plug 'https://github.com/junegunn/vim-plug',
      \ {'on': [], 'do': 'cp plug.vim ' . g:temp_dir}
" }}}

" Helpers                                                                  {{{
  Plug 'https://github.com/vim-scripts/cecutil'

  Plug 'https://github.com/tpope/vim-repeat'

  Plug 'https://github.com/google/vim-maktaba'

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

  silent! call plug#load('vim-alias')

  Plug 'https://github.com/Konfekt/FastFold'
  nmap <SID>(DisableFastFoldUpdate) <Plug>(FastFoldUpdate)
  Plug 'https://github.com/kopischke/vim-stay'

  Plug 'https://github.com/pgdouyon/vim-evanesco'

  Plug 'https://github.com/roxma/vim-tmux-clipboard'

  Plug 'https://github.com/powerman/vim-plugin-viewdoc',
    \ { 'on': ['ViewDocHelp', 'ViewDoc', 'ViewDocMan'] }

  Plug 'https://github.com/tpope/vim-dispatch',
    \ { 'on': ['Make', 'Dispatch'] }
  Plug 'https://github.com/radenling/vim-dispatch-neovim',
    \ { 'on': ['Make', 'Dispatch'] }

  au User vim-dispatch-neovim call DispatchAddNeovim()

  Plug 'https://github.com/romainl/vim-qf'
  let g:qf_auto_open_loclist = 0
  let g:qf_auto_open_quickfix = 0

  if exists('g:use_ycm') && g:use_ycm && has('python3')
    let s:ycm_install = "'./install.py --clangd-completer"

    if executable('rustc') | let s:ycm_install .= ' --rust-completer' | endif
    if executable('go') | let s:ycm_install .= ' --go-completer' | endif
    if executable('node') | let s:ycm_install .= ' --ts-completer' | endif

    if v:version >= 800 || has('nvim')
      execute "Plug 'https://github.com/ycm-core/YouCompleteMe', "
        \. "{ 'do': " . s:ycm_install . "' }"

      Plug 'https://github.com/rdnetto/YCM-Generator',
        \ { 'on': 'YcmGenerateConfig', 'branch': 'stable' }
    endif
  endif
" }}}

" Utility                                                                  {{{
  Plug 'https://github.com/tweekmonster/startuptime.vim',
    \ { 'on': 'StartupTime' }

  Plug 'https://github.com/vim-scripts/Colour-Sampler-Pack',
    \ { 'on': 'COLORSCROLL' }
" }}}

" Appearance and syntax highlighting                                       {{{
  " Plug 'https://github.com/mhinz/vim-startify'

  Plug 'catppuccin/vim', { 'as': 'catppuccin' }

  Plug 'https://github.com/mhinz/vim-hugefile'
  let g:hugefile_trigger_size=500

  Plug 'https://github.com/chriskempson/base16-vim'

  Plug 'https://github.com/powerman/vim-plugin-AnsiEsc',
    \{ 'on': 'AnsiEsc' }

  Plug 'https://github.com/ap/vim-css-color',
    \{ 'for': ['css', 'scss', 'less'] }

  command! AddCSSColors call plug#load('vim-css-color')

  Plug 'https://github.com/luochen1990/rainbow',
    \ helpers#is_modern() ? {} : { 'on': [] }

  " Plug 'https://github.com/sheerun/vim-polyglot'

  Plug 'https://github.com/othree/javascript-libraries-syntax.vim'

  Plug 'https://github.com/neovimhaskell/haskell-vim'

  Plug 'https://github.com/Bellaktris/vim-hack'
  let g:hack#edit_mode = 'XTabedit'
  let g:hack#enable = 0

  Plug 'https://github.com/nelstrom/vim-markdown-folding'

  Plug 'https://github.com/goerz/ipynb_notedown.vim'

  Plug 'https://github.com/artoj/qmake-syntax-vim'

  Plug 'https://github.com/octol/vim-cpp-enhanced-highlight'
  let g:cpp_experimental_template_highlight = 1
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1

  Plug 'https://github.com/vim-scripts/google.vim',
    \ { 'for': ['cpp', 'c', 'objc', 'objcpp'],
    \   'do': 'mv indent/google.vim indent/cpp.vim' }

  Plug 'https://github.com/tpope/vim-sleuth'
  let g:sleuth_automatic = 1

  Plug 'https://github.com/vim-airline/vim-airline'
  Plug 'https://github.com/vim-airline/vim-airline-themes'
" }}}

" Fast scripting and making                                                {{{
  Plug 'https://github.com/skywind3000/asyncrun.vim',
    \ {'on': 'AsyncRun'}

  Plug 'https://github.com/johnsyweb/vim-makeshift',
    \ {'on': 'Makeshift', 'branch': 'main' }
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
    let g:tagbar_autofocus = 0
    let g:tagbar_iconchars = ['▸', '▾']

    Plug 'https://github.com/mhinz/vim-grepper',
    \ { 'on': 'Grepper' }

  Plug 'https://github.com/Olical/vim-enmasse',
    \ { 'on': 'EnMasse' }

  Plug 'https://github.com/junegunn/fzf',
    \ { 'dir': '~/.fzf',
    \   'do': './install --64 --key-bindings --completion --no-update-rc' }

  Plug 'https://github.com/junegunn/fzf.vim'

  Plug 'https://github.com/vim-scripts/a.vim'
  let g:alternateNoDefaultAlternate = 1
  let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../include,sfr:../inc'
" }}}

" Latex                                                                    {{{
  Plug 'https://github.com/lervag/vimtex',
    \ {'for': 'tex'}

  Plug 'https://github.com/KeitaNakamura/tex-conceal.vim',
    \ {'for': 'tex'}
  let g:tex_conceal="mg"
" }}}

" Tmux integration                                                         {{{
  Plug 'https://github.com/christoomey/vim-tmux-navigator'
  let g:tmux_navigator_no_mappings = 1
" }}}

" Git integration                                                          {{{
  Plug 'https://github.com/tpope/vim-fugitive'
  Plug 'https://github.com/junegunn/gv.vim'
  Plug 'https://github.com/int3/vim-extradite'
" }}}

" More power for general editing                                           {{{
  Plug 'https://github.com/tpope/vim-surround'

  Plug 'https://github.com/Bellaktris/latex-unicoder.vim'
  let g:unicoder_cancel_normal = 1
  let g:unicoder_cancel_insert = 1
  let g:unicoder_cancel_visual = 1

  Plug 'https://github.com/junegunn/vim-easy-align',
    \ { 'on': ['<Plug>(EasyAlign)'] }

  Plug 'https://github.com/Bellaktris/vis.vim',
    \ { 'on': ['B', 'S'] }
  execute "xnoremap : :B "
  Plug 'https://github.com/tommcdo/vim-exchange'

  Plug 'https://github.com/mtth/scratch.vim'

  Plug 'https://github.com/mg979/vim-visual-multi', { 'branch': 'master' }
" }}}

" More power for code editing                                              {{{
  Plug 'https://github.com/tpope/vim-commentary'

  Plug 'https://github.com/tpope/vim-abolish'

  Plug 'https://github.com/SirVer/ultisnips', { 'on': [] }

  augroup ultisnips_group | au!
    au InsertEnter * if has('python3') | call plug#load('ultisnips') | endif
          \| au! ultisnips_group
  augroup END

  Plug 'https://github.com/Bellaktris/vim-snippets'
" }}}

" Syntax checking                                                          {{{
  Plug 'https://github.com/benekastah/neomake',
    \ { 'on': 'Neomake' }
" }}}

" IDE features                                                             {{{
  if has('nvim-0.9')
    Plug 'https://github.com/nvim-lua/plenary.nvim'
    Plug 'nvim-treesitter/nvim-treesitter'
  endif

  if has('nvim-0.9') && (!exists('g:use_ycm') || !g:use_ycm)
    Plug 'hrsh7th/cmp-cmdline', { 'branch': 'main' }
    Plug 'hrsh7th/cmp-buffer', { 'branch': 'main' }
    Plug 'hrsh7th/cmp-path', { 'branch': 'main' }
    Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }
  endif

  if has('nvim-0.11') && (!exists('g:use_ycm') || !g:use_ycm)
    Plug 'https://github.com/nvimtools/none-ls.nvim',
      \ { 'branch': 'main' }

    Plug 'nvim-telescope/telescope-fzf-native.nvim',
      \ { 'branch': 'main',
      \   'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    Plug 'https://github.com/nvim-telescope/telescope.nvim'

    Plug 'https://github.com/weilbith/nvim-lsp-smag'
    Plug 'https://github.com/neovim/nvim-lspconfig'

    Plug 'hrsh7th/cmp-nvim-lsp-signature-help', { 'branch': 'main' }
    Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
    Plug 'nvim-lua/lsp-status.nvim'
  endif
" }}}

" Miscelaneus                                                              {{{
  Plug 'https://github.com/csexton/trailertrash.vim'

  Plug 'https://github.com/Chiel92/vim-autoformat'

  Plug 'https://github.com/MarcWeber/vim-addon-local-vimrc'
" }}}

silent! call plug#end()

let g:native_lsp = exists('g:lsp_servers') && !empty(g:lsp_servers)
      \ && (!exists('g:use_ycm') || !g:use_ycm) && has('nvim-0.11')

if !has('nvim')
  echohl WarningMsg | echom "Neovim isn't available, running vim..." | echohl None
endif

let plugins = glob(expand('<sfile>:p:h') . '/plugin-options/*.vim')
for file in split(plugins, '\n') | execute 'source ' . file | endfor

silent! execute 'source ' . g:root_dir . '/vimrc/secret.vim'

function! HasPlug(name)
  return has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
       \ && stridx(&rtp, g:plugs[a:name].dir) >= 0
endfunction

if has('nvim-0.12') && HasPlug('nvim-treesitter')
  lua require('treesitter-options')
endif

if g:native_lsp && HasPlug('telescope.nvim')
  lua require('telescope-options')
endif

if g:native_lsp && HasPlug('null-ls.nvim')
  lua require("null-ls-options")
endif

if g:native_lsp && HasPlug('nvim-lspconfig')
      \ && HasPlug('cmp-nvim-lsp') && HasPlug('nvim-cmp')
  lua require("cmp-nvim-lsp-options")
endif

