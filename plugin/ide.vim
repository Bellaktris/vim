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

let g:bexec_args = g:ide_arglist . " < " . g:ide_stdin
let g:bexec_cpp_script = '/usr/bin/env python3 ' . g:root_dir . '/bexec/cpp.py'
let g:bexec_rust_script = '/usr/bin/env python3 ' . g:root_dir . '/bexec/rust.py'
let g:bexec_filter_types = {}

function! s:RebuildBexecTypes()
  for [s:lang, s:script] in [['cpp', g:bexec_cpp_script], ['rust', g:bexec_rust_script]]
    let g:bexec_filter_types[s:lang] = s:script
          \. ' --args="' . g:ide_compiler_arglist . '" -m "' . g:ide_mode . '"'
  endfor
endfunction

call s:RebuildBexecTypes()

augroup ide_file_hooks | au!
  au BufLeave,BufWrite */ide-stdargs call UpdateStdargs()
  au BufLeave,BufWrite */ide-cpp-stdargs call CCargsRead()
augroup END


" IDE: release/debug mode
function! s:SetMode(mode)
  let g:ide_mode = a:mode
  call s:RebuildBexecTypes()
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
function! UpdateStdargs()
  let g:ide_arglist = join(readfile(g:ide_stdargs), ' ')
  let g:bexec_args = g:ide_arglist . " < " . g:ide_stdin
endfunction

function! CCargsRead()
  let g:ide_compiler_arglist = join(readfile(g:ide_compiler_stdargs), ' ')
  call s:RebuildBexecTypes()
endfunction

command! -nargs=? Stdin
      \ if <q-args> != '' | let g:ide_stdin = glob(<q-args>) | endif
      \ | let g:bexec_args = g:ide_arglist . " < " . g:ide_stdin
      \ | exec 'tabedit ' . g:ide_stdin

command! -nargs=? Stdargs
      \ if <q-args> != '' | let g:ide_stdargs = glob(<q-args>) | endif
      \ | exec 'tabedit ' . g:ide_stdargs

command! -nargs=? CCargs
      \ if <q-args> != '' | let g:ide_compiler_stdargs = glob(<q-args>) | endif
      \ | exec 'tabedit ' . g:ide_compiler_stdargs


" IDE: execute file
function! s:ExecuteFile()
  silent! wall

  let l:width = max([helpers#free_hspace(), 40])

  if has_key(g:bexec_filter_types, &filetype)
    let l:cmd = g:bexec_filter_types[&filetype]
          \ . ' ' . shellescape(expand('%:p'))
          \ . ' ' . g:bexec_args
  else
    let l:shebang = helpers#parse_shebang()
    if l:shebang.exe != ''
      let l:cmd = l:shebang.exe . ' ' . join(l:shebang.args)
            \ . ' ' . shellescape(expand('%:p'))
            \ . ' ' . g:bexec_args
    else
      let l:cmd = shellescape(expand('%:p'))
            \ . ' ' . g:bexec_args
    endif
  endif

  execute l:width . 'vsplit | terminal ' . l:cmd
  setlocal nonumber norelativenumber
  normal! G
endfunction

nmap <silent> <plug>(execute-file) :call <SID>ExecuteFile()<cr>


" IDE: go-to-definition (native LSP → YCM → ctags)
if has('nvim-0.11')
lua << EOF
  function _G.lsp_goto_definition_tab()
    local cur_buf = vim.api.nvim_get_current_buf()
    vim.lsp.buf.definition({
      on_list = function(result)
        if not result or not result.items or #result.items == 0 then return end
        local item = result.items[1]
        local target = item.filename or item.bufnr and vim.api.nvim_buf_get_name(item.bufnr)
        if not target then return end
        local lnum = item.lnum or 1
        local col = item.col or 1
        if target == vim.api.nvim_buf_get_name(cur_buf) then
          vim.api.nvim_win_set_cursor(0, { lnum, col - 1 })
        else
          vim.cmd('tabedit +' .. lnum .. ' ' .. vim.fn.fnameescape(target))
          vim.api.nvim_win_set_cursor(0, { lnum, col - 1 })
        end
      end,
    })
  end
EOF
endif

function! JumpToDefinition()
  if exists('g:native_lsp') && g:native_lsp
    lua lsp_goto_definition_tab()
    return
  endif

  if exists(':YcmCompleter') == 2
    try
      let l:cmds = py3eval('ycm_state.GetDefinedSubcommands()')
      for l:cmd in ['GoTo', 'GoToDefinition', 'GoToDeclaration']
        if index(l:cmds, l:cmd) >= 0
          execute 'YcmCompleter' l:cmd
          return
        endif
      endfor
    catch
    endtry
  endif

  try
    execute "normal! g]"
  catch /E426\|E433/
    echohl WarningMsg | echo "No definition found" | echohl None
  endtry
endfunction


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
