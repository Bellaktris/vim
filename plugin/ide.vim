" IDE: build/run configuration

let g:ide_stdin   = g:temp_dir . '/ide-stdin'
let g:ide_stdargs = g:temp_dir . '/ide-stdargs'
let g:ide_compiler_stdargs = g:temp_dir . '/ide-cpp-stdargs'

for s:f in [g:ide_stdin, g:ide_stdargs, g:ide_compiler_stdargs]
  if !filereadable(s:f) | execute 'silent !touch ' . s:f | endif
endfor

let g:ide_arglist = join(readfile(g:ide_stdargs), ' ')
let g:ide_compiler_arglist = join(readfile(g:ide_compiler_stdargs), ' ')
let g:ide_mode = 'release'

let g:ide_run_args = g:ide_arglist . " < " . g:ide_stdin
let g:ide_cpp_runner = '/usr/bin/env python3 ' . g:root_dir . '/runners/cpp.py'
let g:ide_rust_runner = '/usr/bin/env python3 ' . g:root_dir . '/runners/rust.py'
let g:ide_runners = {}

function! s:RebuildRunners()
  for [s:lang, s:script] in [['cpp', g:ide_cpp_runner], ['rust', g:ide_rust_runner]]
    let g:ide_runners[s:lang] = s:script
          \. ' --args="' . g:ide_compiler_arglist . '" -m "' . g:ide_mode . '"'
  endfor
endfunction

call s:RebuildRunners()

function! s:RebuildMakeshiftSystems()
  let l:type = g:ide_mode ==# 'debug' ? 'Debug' : 'Release'
  let l:dir = 'build-' . g:ide_mode
  let l:buck_mode = g:ide_mode ==# 'debug' ? 'dev' : 'opt'

  let l:cmake = 'mkdir -p ' . l:dir . ' && cd ' . l:dir
        \. ' && cmake -DCMAKE_BUILD_TYPE=' . l:type
  if g:ide_compiler_arglist != ''
    let l:cmake .= ' -DCMAKE_CXX_FLAGS="' . g:ide_compiler_arglist . '"'
  endif

  if executable('ninja')
    let g:makeshift_systems = {
      \ 'CMakeLists.txt': l:cmake . ' -G Ninja .. && ninja',
    \}
  else
    let g:makeshift_systems = {
      \ 'CMakeLists.txt': l:cmake . ' .. && make',
    \}
  endif

  let g:makeshift_systems['BUILD'] =
    \'blaze build --color=no --curses=no'

  let g:makeshift_systems['TARGETS'] =
    \'buck build @mode/' . l:buck_mode
    \. ' /${PWD#$HOME/fbsource/fbcode}/...'
endfunction

call s:RebuildMakeshiftSystems()

augroup ide_file_hooks | au!
  au BufLeave,BufWrite */ide-stdargs call UpdateStdargs()
  au BufLeave,BufWrite */ide-cpp-stdargs call CCargsRead()
augroup END


" IDE: release/debug mode
function! s:SetMode(mode)
  let g:ide_mode = a:mode
  call s:RebuildRunners()
  call s:RebuildMakeshiftSystems()
  set makeprg=make
endfunction

command! Release call s:SetMode('release')
command! Debug call s:SetMode('debug')

if exists(':Alias')
  call Alias(0, 'release', 'Release')
  call Alias(0, 'debug', 'Debug')
  call Alias(0, 'stdin', 'Stdin')
  call Alias(0, 'stdargs', 'Stdargs')
  call Alias(0, 'ccargs', 'CCargs')
endif


" IDE: stdin/stdargs/ccargs
function! s:EditIdeFile(varname, ...)
  if a:0 && a:1 != '' | let g:{a:varname} = glob(a:1) | endif
  execute 'tabedit ' . g:{a:varname}
endfunction

function! UpdateStdargs()
  let g:ide_arglist = join(readfile(g:ide_stdargs), ' ')
  let g:ide_run_args = g:ide_arglist . " < " . g:ide_stdin
endfunction

function! CCargsRead()
  let g:ide_compiler_arglist = join(readfile(g:ide_compiler_stdargs), ' ')
  call s:RebuildRunners()
  call s:RebuildMakeshiftSystems()
  set makeprg=make
endfunction

command! -nargs=? Stdin call s:EditIdeFile('ide_stdin', <f-args>)
      \ | let g:ide_run_args = g:ide_arglist . " < " . g:ide_stdin
command! -nargs=? Stdargs call s:EditIdeFile('ide_stdargs', <f-args>)
command! -nargs=? CCargs call s:EditIdeFile('ide_compiler_stdargs', <f-args>)


" IDE: execute file
function! s:ExecuteFile()
  silent! wall

  let l:width = max([helpers#free_hspace(), 40])

  if has_key(g:ide_runners, &filetype)
    let l:cmd = g:ide_runners[&filetype]
          \ . ' ' . shellescape(expand('%:p'))
          \ . ' ' . g:ide_run_args
  else
    let l:shebang = helpers#parse_shebang()
    if l:shebang.exe != ''
      let l:cmd = l:shebang.exe . ' ' . join(l:shebang.args)
            \ . ' ' . shellescape(expand('%:p'))
            \ . ' ' . g:ide_run_args
    else
      let l:cmd = shellescape(expand('%:p'))
            \ . ' ' . g:ide_run_args
    endif
  endif

  execute l:width . 'vsplit | terminal ' . l:cmd
  setlocal nonumber norelativenumber
  normal! G
endfunction

nmap <silent> <plug>(execute-file) :call <SID>ExecuteFile()<cr>


" IDE: navigate to file:line, reusing existing tab or opening new one
function! s:GotoLocation(file, lnum, col)
  let l:target = fnamemodify(a:file, ':p')
  let l:cur = expand('%:p')

  " Mark jumplist before navigating
  normal! m'

  " Same file — just move cursor
  if l:target ==# l:cur
    call cursor(a:lnum, a:col)
    normal! zv
    return
  endif

  " Check all tabs for a window showing this file
  for l:tab in range(1, tabpagenr('$'))
    for l:win_bufnr in tabpagebuflist(l:tab)
      if fnamemodify(bufname(l:win_bufnr), ':p') ==# l:target
        execute 'tabnext' l:tab
        execute bufwinnr(l:win_bufnr) . 'wincmd w'
        call cursor(a:lnum, a:col)
        normal! zv
        return
      endif
    endfor
  endfor

  " Not open anywhere — new tab
  execute 'tabedit ' . fnameescape(l:target)
  call cursor(a:lnum, a:col)
  normal! zv
endfunction

" YCM helper: run a YCM command and capture the jump via s:GotoLocation
function! s:YcmGoto(cmd)
  let l:orig_file = expand('%:p')
  let l:orig_pos = getpos('.')
  execute 'YcmCompleter' a:cmd
  let l:new_file = expand('%:p')
  let l:new_pos = getpos('.')
  if l:new_file !=# l:orig_file || l:new_pos != l:orig_pos
    " YCM jumped — undo its jump and redo via our tab-reuse logic
    execute 'buffer ' . bufnr(l:orig_file)
    call setpos('.', l:orig_pos)
    call s:GotoLocation(l:new_file, l:new_pos[1], l:new_pos[2])
  endif
endfunction

" LSP goto with tab reuse
if has('nvim-0.11')
lua << EOF
  function _G.lsp_goto(method)
    method = method or 'definition'
    vim.lsp.buf[method]({
      on_list = function(result)
        if not result or not result.items or #result.items == 0 then return end
        local item = result.items[1]
        local target = item.filename or (item.bufnr and vim.api.nvim_buf_get_name(item.bufnr))
        if not target then return end
        vim.fn['s:GotoLocation'](target, item.lnum or 1, item.col or 1)
      end,
    })
  end
EOF
endif


" IDE: go-to-definition (native LSP → YCM → ctags)
function! JumpToDefinition()
  if exists('g:native_lsp') && g:native_lsp
    lua lsp_goto('definition')
    return
  endif

  if exists(':YcmCompleter') == 2
    try
      let l:cmds = py3eval('ycm_state.GetDefinedSubcommands()')
      for l:cmd in ['GoTo', 'GoToDefinition', 'GoToDeclaration']
        if index(l:cmds, l:cmd) >= 0
          call s:YcmGoto(l:cmd)
          return
        endif
      endfor
    catch
    endtry
  endif

  try
    execute "normal! g\<c-]>"
  catch /E426\|E433/
    echohl WarningMsg | echo "No definition found" | echohl None
  endtry
endfunction


" IDE: go-to-include (native LSP → YCM → vim gf)
function! GoToInclude()
  if exists('g:native_lsp') && g:native_lsp
    lua lsp_goto('definition')
    return
  endif

  if exists(':YcmCompleter') == 2
    try
      let l:cmds = py3eval('ycm_state.GetDefinedSubcommands()')
      if index(l:cmds, 'GoToInclude') >= 0
        call s:YcmGoto('GoToInclude')
        return
      endif
    catch
    endtry
  endif

  let l:file = expand('<cfile>')
  if filereadable(l:file)
    call s:GotoLocation(l:file, 1, 1)
  else
    execute "normal! \<c-w>gf"
  endif
endfunction


" IDE: find references (native LSP → YCM → ctags)
function! FindReferences()
  if exists('g:native_lsp') && g:native_lsp
    lua vim.lsp.buf.references()
    return
  endif

  if exists(':YcmCompleter') == 2
    try
      let l:cmds = py3eval('ycm_state.GetDefinedSubcommands()')
      if index(l:cmds, 'GoToReferences') >= 0
        YcmCompleter GoToReferences
        return
      endif
    catch
    endtry
  endif

  try
    execute "normal! g]"
  catch /E426\|E433/
    echohl WarningMsg | echo "No references found" | echohl None
  endtry
endfunction


" IDE: jedi call signatures (Python, via floating window)
if has('python3') && has('nvim')
  execute 'command! -nargs=1 PythonJedi python3 <args>'

  augroup jedi_init | au!
    au FileType python
          \ execute "python3 sys.path.insert(0, '" . g:root_dir . "')"
          \| execute "python3 import jedi_signatures"
          \| au! jedi_init
  augroup END

  function! s:JediShowCallSignatures()
    PythonJedi jedi_signatures.show_call_signatures()
  endfunction

  function! s:JediClearCallSignatures()
    PythonJedi jedi_signatures.clear_call_signatures()
  endfunction

  augroup jedi_signatures | au!
    au FileType python
          \ autocmd CursorMovedI <buffer> call s:JediShowCallSignatures()
          \| autocmd InsertLeave <buffer> call s:JediClearCallSignatures()
  augroup END
endif


" IDE: code search (grep wrappers)
function! FastGrepFirstRoot(line, opts)
    execute 'lcd ' . helpers#find_git_root()
    execute "Grepper -query " . a:opts . ' ' . helpers#shellescape(a:line)
endfunction

function! FastGrepLastRoot(line, opts)
    let l:first_root = helpers#find_git_root()
    let l:last_root = helpers#find_last_root()

    if l:first_root != l:last_root
        execute 'lcd ' . l:last_root
    else
        execute "cd " . expand("%:p:h")
    endif
    execute "Grepper -query " . a:opts . ' ' . helpers#shellescape(a:line)
endfunction

command! -nargs=* FastGrepU call FastGrepFirstRoot('<args>', '')
command! -nargs=* FastGrepL call FastGrepLastRoot('<args>', '')
