if !exists('g:loaded_nerd_tree')
  call plug#load('nerdtree-git-plugin', 'nerdtree')
  call g:NERDTreeCreator.CreateWindowTree(expand('%:p'))

  call plug#load('vim-airline')
  call plug#load('vim-airline-themes')
endif

setlocal colorcolumn=0
