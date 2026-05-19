#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Installation of .vimrc and dependencies."""

import subprocess
import os


ROOTDIR = os.path.dirname(os.path.abspath(__file__))
HOME = os.path.expanduser('~')

VIMRCDIR = ROOTDIR + '/vimrc'
SNIPPETDIR = ROOTDIR + '/ultisnips'
TEMPDIR = HOME + '/.tempd'
PLUGDIR = HOME + '/.vim-thirdparty'


VIMRC = rf'''
if !exists('g:root_dir')
  let g:vimrc_dir = "{VIMRCDIR}"
  let g:temp_dir = "{TEMPDIR}"
  let g:snippet_dir = "{SNIPPETDIR}"

  if !isdirectory(g:temp_dir)
      execute 'silent !mkdir -p ' . g:temp_dir
  endif

  if !isdirectory($HOME . '/.vim')
      execute 'silent !mkdir -p ' . $HOME . '/.vim'
  endif

  let g:use_ycm = 1
  let g:root_dir = "{ROOTDIR}"
  let g:vim_plug_dir = "{PLUGDIR}"

  execute 'let &runtimepath .=",' . g:root_dir . '"'

  execute 'source ' . g:vimrc_dir . '/main.vim'

  " YCM's VimEnter doesn't fire when init.vim sources .vimrc.
  if has('nvim') && has('python3')
    call timer_start(0, {{-> execute('silent! call youcompleteme#Enable()')}})
  endif
endif'''

for d in [TEMPDIR + '/undodir', SNIPPETDIR]:
    os.makedirs(d, exist_ok=True)

open(VIMRCDIR + '/secret.vim', 'a').close()

XDG_NVIM = HOME + '/.config/nvim'
os.makedirs(XDG_NVIM, exist_ok=True)

with open(HOME + '/.vimrc', 'w') as f:
    f.write(VIMRC)

with open(XDG_NVIM + '/init.vim', 'w') as f:
    f.write('source $HOME/.vimrc\n')

AUTOINSTALL = "exec 'PlugInstall | UpdateRemotePlugins' | exec 'qa'"

try:
    subprocess.call(['nvim', '-c', AUTOINSTALL])
except OSError:
    subprocess.call(['vim', '-c', AUTOINSTALL])
