#!/usr/bin/env python3
# -*- coding: <utf-8> -*-

"""Installation of .vimrc and dependencies."""


import subprocess
import os


ROOTDIR = os.path.dirname(os.path.abspath(__file__))

VIMRCDIR = ROOTDIR + '/vimrc'

SNIPPETDIR = ROOTDIR + '/ultisnips'
TEMPDIR = ROOTDIR + '/tempd'


VIMRC = r'''
if !exists('g:root_dir')
  let g:vimrc_dir = "''' + VIMRCDIR + r'''"
  let g:temp_dir = "''' + TEMPDIR + r'''"
  let g:snippet_dir = "''' + SNIPPETDIR + r'''"

  let g:root_dir = "''' + ROOTDIR + r'''"
  let g:vim_plug_dir = g:root_dir . '/thirdparty'

  execute 'let &runtimepath .=",' . g:root_dir . '"'

  execute 'source ' . g:vimrc_dir . '/main.vim'
endif'''

if not os.path.exists(TEMPDIR + '/undodir'):
    os.makedirs(TEMPDIR + '/undodir')

    if not os.path.exists(SNIPPETDIR):
        os.makedirs(SNIPPETDIR)

open(VIMRCDIR + '/secret.vim', 'a').close()

XDG_NVIM = os.path.expanduser('~/.config/nvim')
if not os.path.exists(XDG_NVIM):
    os.makedirs(XDG_NVIM)

with open(os.path.expanduser('~/.vimrc'), 'w') as config:
    config.write(VIMRC)
    with open(XDG_NVIM + '/init.vim', 'w') as config:
        config.write('set termguicolors\nsource ~/.vimrc\n')

AUTOINSTALL = "exec 'PlugInstall | UpdateRemotePlugins' | exec 'qa'"

try:
    subprocess.call(['nvim', '-c', AUTOINSTALL])
except OSError:
    subprocess.call(['vim',  '-c', AUTOINSTALL])
