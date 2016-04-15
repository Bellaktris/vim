let g:ide_stdin   = g:temp_dir . '/ide-stdin'
let g:ide_stdargs = g:temp_dir . '/ide-stdargs'
let g:ide_compiler_stdargs = g:temp_dir . '/ide-cpp-stdargs'

if !filereadable(g:ide_stdin)
    execute 'silent !touch ' . g:ide_stdin
endif
if !filereadable(g:ide_stdargs)
    execute 'silent !touch ' . g:ide_stdargs
endif
if !filereadable(g:ide_compiler_stdargs)
    execute 'silent !touch ' . g:ide_compiler_stdargs
endif

let g:ide_arglist = join(readfile(g:ide_stdargs), ' ')
let g:ide_compiler_arglist = join(readfile(g:ide_compiler_stdargs), ' ')
let g:ide_mode = 'release'

let g:bexec_args = g:ide_arglist . " < " . g:ide_stdin

let g:bexec_cpp_script = '/usr/bin/env python3 ' . g:root_dir . '/bexec/cpp.py'
let g:bexec_rust_script = '/usr/bin/env python3 ' . g:root_dir . '/bexec/rust.py'

let g:bexec_filter_types = {}
let g:bexec_filter_types['cpp'] = g:bexec_cpp_script
    \. ' --args="' . g:ide_compiler_arglist . '" -m "' . g:ide_mode . '"'
let g:bexec_filter_types['rust'] = g:bexec_rust_script
    \. ' --args="' . g:ide_compiler_arglist . '" -m "' . g:ide_mode . '"'

autocmd! BufLeave,BufWrite */ide-stdargs call UpdateStdargs()
autocmd! BufLeave,BufWrite */ide-cpp-stdargs call CCargsRead()


command! Release call s:ReleaseFunc()
if exists(':Alias')
    Alias release Release
endif

command! Debug call s:DebugFunc()
if exists(':Alias')
    Alias debug Debug
endif

command! -nargs=1 Timeout call s:TimeoutFunc(<f-args>)
if exists(':Alias')
    Alias timeout Timeout
endif

function! s:ReleaseFunc(...)
    let g:ide_mode = 'release'
    let g:bexec_filter_types['cpp'] = g:bexec_cpp_script
        \. ' --args="' . g:ide_compiler_arglist . '" -m "' . g:ide_mode . '"'
    let g:bexec_filter_types['rust'] = g:bexec_rust_script
        \. ' --args="' . g:ide_compiler_arglist . '" -m "' . g:ide_mode . '"'
endfunction

function! s:DebugFunc(...)
    let g:ide_mode = 'debug'
    let g:bexec_filter_types['cpp'] = g:bexec_cpp_script
        \. ' --args="' . g:ide_compiler_arglist . '" -m "' . g:ide_mode . '"'
    let g:bexec_filter_types['rust'] = g:bexec_rust_script
        \. ' --args="' . g:ide_compiler_arglist . '" -m "' . g:ide_mode . '"'
endfunction

function! s:TimeoutFunc(...)
endfunction

command! -nargs=? Stdin call s:StdinFunc(<f-args>)
if exists(':Alias')
    Alias stdin Stdin
endif

function! s:StdinFunc(...)
    if a:0 != 0
        let g:ide_stdin = glob(a:1)
    endif

    let g:bexec_args = g:ide_arglist . " < " . g:ide_stdin
    exec 'tabedit ' . g:ide_stdin
endfunction

command! -nargs=? Stdargs call s:StdargsFunc(<f-args>)
if exists(':Alias')
    Alias stdargs Stdargs
endif

function! UpdateStdargs()
    let g:ide_arglist = join(readfile(g:ide_stdargs), ' ')
    let g:bexec_args = g:ide_arglist . " < " . g:ide_stdin
endfunction

function! s:StdargsFunc(...)
    if a:0 != 0
        let g:ide_stdargs = glob(a:1)
    endif

    exec 'tabedit ' . g:ide_stdargs
endfunction

command! -nargs=? CCargs call s:CCargsFunc(<f-args>)
if exists(':Alias')
    Alias ccargs CCargs
endif

function! CCargsRead()
    let g:ide_compiler_arglist = join(readfile(g:ide_compiler_stdargs), ' ')

    let g:bexec_filter_types['cpp'] = g:bexec_cpp_script
        \. ' --args="' . g:ide_compiler_arglist . '" -m "' . g:ide_mode . '"'
    let g:bexec_filter_types['rust'] = g:bexec_cpp_script
        \. ' --args="' . g:ide_compiler_arglist . '" -m "' . g:ide_mode . '"'
endfunction

function! s:CCargsFunc(...)
    if a:0 != 0
        let g:ide_compiler_stdargs = glob(a:1)
    endif

    exec 'tabedit ' . g:ide_compiler_stdargs
endfunction
