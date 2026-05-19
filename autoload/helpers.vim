function! helpers#is_modern()
    return has('nvim') || has('gui')
endfunction

function! helpers#is_small()
    return getfsize(expand('<afile>')) <= 1048576 * g:largefile_trigger_size
endfunction

function! helpers#call_from_dir(cmd, dir)
    let s:tmp_path = getcwd()
    execute 'lcd ' . a:dir
    execute a:cmd
    execute 'lcd '.s:tmp_path
endfunction

function! helpers#call_from_git_root(cmd)
    call helpers#call_from_dir(a:cmd, helpers#find_git_root())
endfunction

function! helpers#call_from_last_root_dir(cmd)
    call helpers#call_from_dir(a:cmd, helpers#find_last_root())
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
endfunction

function! helpers#parse_shebang() abort
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
        if exists('*FugitiveGitDir')
            let s:git_dir = FugitiveGitDir()
            if !empty(s:git_dir)
              let s:rootdir = fnamemodify(s:git_dir, ':h')
            endif
        elseif executable('git')
            let s:rootdir = system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
        endif
    endif

    silent! execute 'lcd '.s:tmp_path

    if s:rootdir != ""
        return s:rootdir
    else
        return getcwd()
    endif
endfunction

function! helpers#find_last_root()
    return helpers#find_git_root(1)
endfunction

function! helpers#goto_location(file, ...)
    let l:lnum = a:0 >= 1 ? a:1 : 0
    let l:col = a:0 >= 2 ? a:2 : 1
    let l:target = fnamemodify(a:file, ':p')

    if l:lnum > 0
      normal! m'
    endif

    if l:target ==# expand('%:p')
      if l:lnum > 0
        call cursor(l:lnum, l:col)
        normal! zv
      endif
      return
    endif

    for l:tab in range(1, tabpagenr('$'))
      for l:bufnr in tabpagebuflist(l:tab)
        if fnamemodify(bufname(l:bufnr), ':p') ==# l:target
          execute 'tabnext' l:tab
          execute bufwinnr(l:bufnr) . 'wincmd w'
          if l:lnum > 0
            call cursor(l:lnum, l:col)
            normal! zv
          endif
          return
        endif
      endfor
    endfor

    execute 'tabedit ' . fnameescape(l:target)
    if l:lnum > 0
      call cursor(l:lnum, l:col)
      normal! zv
    endif
endfunction

function! helpers#open_new_or_existing(buf_name)
    call helpers#goto_location(a:buf_name)
endfunction

function! helpers#setup_goto_mappings()
    nnoremap <silent><buffer> g<c-]> :call JumpToDefinition()<cr>
    nnoremap <silent><buffer> gd :call JumpToDefinition()<cr>
    nnoremap <silent><buffer> gD :call JumpToDefinition()<cr>
    nnoremap <silent><buffer> g] :call FindReferences()<cr>
endfunction

function! helpers#setup_grep(tool)
    if !executable(a:tool) | return | endif
    execute 'xmap <silent><buffer> <leader>ag y:execute "lcd ".helpers#find_git_root()<cr>'
          \ . ':exe "Grepper -noprompt -grepprg ' . a:tool . ' -i -s "'
          \ . '. helpers#shellescape(substitute(@0, ''--'', '''', ''g''))<cr>'
    execute 'command! -buffer -nargs=* FastGrep execute "Grepper -noprompt -grepprg '
          \ . a:tool . ' -i -s ".helpers#shellescape(''<args>'')'
endfunction
