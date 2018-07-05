function! helpers#is_modern()
    return has('nvim') || has('gui')
endfunction

function! helpers#is_small()
    return getfsize(expand('<afile>')) <= 1048576 * g:largefile_trigger_size
endfunction

function! helpers#call_from_here(cmd)
    let s:tmp_path = getcwd()
    lcd %:p:h

    execute a:cmd

    execute 'lcd '.s:tmp_path
endfunction

function! helpers#free_hspace()
    redir =>a
        exe "sil sign place buffer=".bufnr('')
    redir end

    let signwidth = len(split(a, '\n')) > 2 ? 2 : 0
    let actualwidth = winwidth('%') - &numberwidth - &foldcolumn - signwidth

    let result = actualwidth - g:colorcolumn
    return result > 40 ? result : 40
endfunction

function! helpers#shellescape(str)
    let esc = '\[\]"#&|<>()@^ \\'."'"

    return &shellquote . substitute(a:str, '['.esc.']', '\\&', 'g') .
          \ get({'(': ')', '"(': ')"'}, &shellquote, &shellquote)
    endif
endfunction

function! helpers#parse_shebang() abort " {{{2
    for lnum in range(1, 5)
        let line = getline(lnum)
        if line =~# '^#!'
            let line = substitute(line, '\v^#!\s*(\S+/env(\s+-\S+)*\s+)?', '', '')
            let exe = matchstr(line, '\m^\S*\ze')
            let args = split(matchstr(line, '\m^\S*\zs.*'))
            return { 'exe': exe, 'args': args }
        endif
    endfor

    return { 'exe': '', 'args': [] }
endfunction

function! helpers#find_git_root(...)
    let l:count = -1

    if a:0 == 1
        let l:count = a:1
    endif

    let s:tmp_path = getcwd()
    silent! lcd %:p:h

    let s:rootdir = ""

    if exists('*FindRootDirectory')
        let s:rootdir = FindRootDirectory(l:count)
    else
        if exists('*fugitive#repo')
            try
              let s:rootdir = fugitive#repo().tree()
            catch
            endtry
        elseif executable('git')
            let s:rootdir = system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
        endif
    endif

    if s:rootdir != ""
        return s:rootdir
    else
        return getcwd()

    silent! execute 'lcd '.s:tmp_path
endfunction

function! helpers#find_last_root()
    return helpers#find_git_root(1)
endfunction

function! helpers#call_from_current_dir(cmd)
    let s:tmp_path = getcwd()
    lcd %:p:h

    execute a:cmd

    execute 'lcd '.s:tmp_path
endfunction

function! helpers#call_from_git_root(cmd)
    let s:tmp_path = getcwd()
    lcd %:p:h
    execute 'lcd '.helpers#find_git_root()

    execute a:cmd

    execute 'lcd '.s:tmp_path
endfunction

function! helpers#call_from_last_root_dir(cmd)
    let s:tmp_path = getcwd()
    lcd %:p:h
    execute 'lcd '.helpers#find_last_root()

    execute a:cmd

    execute 'lcd '.s:tmp_path
endfunction

function! helpers#open_new_or_existing(buf_name)
    let l:buf_id = bufnr(a:buf_name)
    let l:win_ids = win_findbuf(l:buf_id)
    if len(l:win_ids) != 0
        call win_gotoid(l:win_ids[0])
    else
        exec "tabedit " . a:buf_name
    endif  " len(l:bufs) == 0
endfunction
