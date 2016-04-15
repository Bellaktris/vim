" Vim plugin to change the working directory to the project root.
"
" Copyright 2010-2016 Andrew Stewart, <boss@airbladesoftware.com>
" Released under the MIT licence.

if exists('g:loaded_rooter') || &cp
  finish
endif
let g:loaded_rooter = 1

let s:nomodeline = (v:version > 703 || (v:version == 703 && has('patch442'))) ? '<nomodeline>' : ''

if exists('+autochdir') && &autochdir
  set noautochdir
endif

if !exists('g:rooter_use_lcd')
  let g:rooter_use_lcd = 1
endif

if !exists('g:rooter_patterns')
  let g:rooter_patterns =
  \ [
      \ 'CMakeLists.txt',
      \ 'configure',
      \ 'Makefile',
      \ 'build.ninja',
      \ 'TARGETS',
      \ 'BUCK',
      \ '*.pro',
      \ 'Jamfile',
      \ 'Rakefile',
      \ 'GNUmakefile',
      \ 'SConstruct',
      \ 'mix.exs',
      \ 'pom.xml',
      \ 'build.gradle',
      \ 'build.xml',
      \ '.hgignore',
      \ '.gitignore',
      \ '.git/',
      \ '.svn/',
      \ '.hg/',
      \ '.bzr/',
      \ '_darcs/',
      \ '.buckconfig',
      \ '.arcconfig',
      \ 'compile_commands.json',
  \ ]
endif

if !exists('g:rooter_targets')
  let g:rooter_targets = '/,*'
endif

if !exists('g:rooter_change_directory_for_non_project_files')
  let g:rooter_change_directory_for_non_project_files = 'current'
endif

if !exists('g:rooter_silent_chdir')
  let g:rooter_silent_chdir = 1
endif

if !exists('g:rooter_resolve_links')
  let g:rooter_resolve_links = 1
endif

function! s:ChangeDirectory(directory)
  if a:directory !=# getcwd()
    let cmd = g:rooter_use_lcd == 1 ? 'lcd' : 'cd'
    execute ':'.cmd fnameescape(a:directory)
    if !g:rooter_silent_chdir
      echo 'cwd: '.a:directory
    endif
    execute 'silent doautocmd' s:nomodeline 'User RooterChDir'
  endif
endfunction

function! s:IsDirectory(pattern)
  return stridx(a:pattern, '/') != -1
endfunction

function! s:ChangeDirectoryForBuffer()
  let patterns = split(g:rooter_targets, ',')

  if isdirectory(s:fd)
    return index(patterns, '/') != -1
  endif

  if filereadable(s:fd) && empty(&buftype)
    if exists('*glob2regpat')
      for p in patterns
        if p !=# '/' && s:fd =~# glob2regpat(p)
          return 1
        endif
      endfor
    else
      return 1
    endif
  endif

  return 0
endfunction

function! s:FindAncestor(pattern, count)
  let l:fd_dir = isdirectory(s:fd) ? s:fd : fnamemodify(s:fd, ':h')

  if a:count == -1
    let l:code_path = resolve($HOME . '/fbsource/fbcode')
    if l:fd_dir =~ l:code_path | return l:code_path | endif

    let l:code_path = resolve($HOME . '/fbsource/fbandroid')
    if l:fd_dir =~ l:code_path | return l:code_path | endif

    let l:code_path = resolve($HOME . '/fbsource/fbobjc')
    if l:fd_dir =~ l:code_path | return l:code_path | endif

    let l:code_path = resolve($HOME . '/fbsource/xplat')
    if l:fd_dir =~ l:code_path | return l:code_path | endif

    let l:code_path = resolve($HOME . '/fbsource/tools')
    if l:fd_dir =~ l:code_path | return l:code_path | endif
  endif

  if s:IsDirectory(a:pattern)
    let match = finddir(a:pattern, fnameescape(l:fd_dir).';', a:count)
  else
    let match = findfile(a:pattern, fnameescape(l:fd_dir).';', a:count)
  endif

  if empty(match)
    return ''
  endif

  if a:count == -1
    let match = match[-1]
  endif

  if s:IsDirectory(a:pattern)
    return fnamemodify(match, ':p:h:h')
  else
    return fnamemodify(match, ':p:h')
  endif
endfunction

function! s:SearchForRootDirectory(count)
  for pattern in g:rooter_patterns
    let result = s:FindAncestor(pattern, a:count)
    if !empty(result)
      return result
    endif
  endfor
  return ''
endfunction

function! s:RootDirectory(count)
  let root_dir = getbufvar('%', 'rootDir' . max([a:count, 0]))
  if empty(root_dir)
    let root_dir = s:SearchForRootDirectory(a:count)
    if !empty(root_dir)
      call setbufvar('%', 'rootDir' . max([a:count, 0]), root_dir)
    endif
  endif
  return root_dir
endfunction

function! s:ChangeToRootDirectory()
  let s:fd = expand('%:p')

  if g:rooter_resolve_links
    let s:fd = resolve(s:fd)
  endif

  if !s:ChangeDirectoryForBuffer()
    return
  endif

  let root_dir = s:RootDirectory(a:count)
  if empty(root_dir)
    " Test against 1 for backwards compatibility
    if g:rooter_change_directory_for_non_project_files == 1 ||
          \ g:rooter_change_directory_for_non_project_files ==? 'current'
      call s:ChangeDirectory(fnamemodify(s:fd, ':h'))
    elseif g:rooter_change_directory_for_non_project_files ==? 'home'
      call s:ChangeDirectory($HOME)
    endif
  else
    call s:ChangeDirectory(root_dir)
  endif
endfunction

" For third-parties.  Not used by plugin.
function! FindRootDirectory(count)
  let s:fd = expand('%:p')

  if g:rooter_resolve_links
    let s:fd = resolve(s:fd)
  endif

  if !s:ChangeDirectoryForBuffer()
    return ''
  endif

  return s:RootDirectory(a:count)
endfunction

command! Rooter :call <SID>ChangeToRootDirectory(-1)

if !exists('g:rooter_manual_only')
  augroup rooter
    autocmd!
    autocmd BufEnter * :Rooter
  augroup END
endif

" vim:set ft=vim sw=2 sts=2 et:
