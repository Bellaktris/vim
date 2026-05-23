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

" Populate the qflist with diagnostics for the current buffer and open it.
" severity_max: 'E' (errors only) or 'I' (errors + warnings + info).
" Priority: vim.diagnostic (native LSP) -> YCM (:YcmDiags) -> existing loclist
" (typically neomake). We populate the qflist rather than the loclist so the
" jump-from-qf doesn't get clobbered by neomake's BufEnter autocmd (which
" rewrites the loclist on every buffer enter).
function! helpers#open_diagnostics(severity_max) abort
    let l:bufnr = bufnr('')
    let l:want = a:severity_max ==# 'E' ? ['E'] : ['E', 'W', 'I']
    let l:Match = {idx, val -> val.bufnr == l:bufnr
        \ && index(l:want, toupper(val.type)) >= 0}

    if has('nvim') && !empty(luaeval('vim.diagnostic.get(0)'))
        let l:sev = a:severity_max ==# 'E'
            \ ? 'vim.diagnostic.severity.ERROR'
            \ : '{ max = vim.diagnostic.severity.INFO }'
        let l:items = luaeval(
            \ 'vim.diagnostic.toqflist(vim.diagnostic.get(0, { severity = '
            \ . l:sev . ' }))')
        if !empty(l:items)
            call s:set_diagnostics_qf(l:items)
            return
        endif
    endif

    let l:saved_loc = getloclist(0)

    if exists(':YcmDiags') == 2
        silent! YcmDiags
        let l:items = filter(getloclist(0), l:Match)
        call setloclist(0, l:saved_loc, 'r')
        if !empty(l:items)
            call s:set_diagnostics_qf(l:items)
            return
        endif
    endif

    let l:items = filter(copy(l:saved_loc), l:Match)
    if !empty(l:items)
        call s:set_diagnostics_qf(l:items)
        return
    endif

    cclose
    silent! lclose
    echohl WarningMsg | echom 'No diagnostics' | echohl None
endfunction

" Populate the qflist with the diagnostic items and open the window. Uses a
" per-list quickfixtextfunc so only this qflist hides the path column; other
" qf consumers (grep, fugitive, neomake) keep vim's default rendering.
function! s:set_diagnostics_qf(items) abort
    call setqflist([], 'r', {
        \ 'items': a:items,
        \ 'title': 'Diagnostics',
        \ 'quickfixtextfunc': function('helpers#qf_format_pathless'),
        \ })
    call s:open_qflist_capped()
    " :copen leaves the cursor in the qf window, so matchadd targets it.
    call s:apply_diagnostics_highlights()
endfunction

" Window-local syntax-via-matchadd for the diagnostic qf format. Links to the
" standard nvim Diagnostic*/LineNr/Number/Comment/NonText groups so the
" colorscheme controls the actual colors (starsky has Diagnostic* tuned).
function! s:apply_diagnostics_highlights() abort
    silent! highlight default link qfDiagLineNr   LineNr
    silent! highlight default link qfDiagColLabel Comment
    silent! highlight default link qfDiagColNum   Number
    silent! highlight default link qfDiagError    DiagnosticError
    silent! highlight default link qfDiagWarning  DiagnosticWarn
    silent! highlight default link qfDiagInfo     DiagnosticInfo
    silent! highlight default link qfDiagHint     DiagnosticHint
    silent! highlight default link qfDiagSep      NonText

    for l:m in getmatches()
        if get(l:m, 'group', '') =~# '^qfDiag'
            call matchdelete(l:m.id)
        endif
    endfor

    let l:sep = nr2char(0x2502)
    call matchadd('qfDiagLineNr',   '^ *\d\+\ze col ')
    call matchadd('qfDiagColLabel', ' col ')
    call matchadd('qfDiagColNum',   ' col \zs\d\+')
    call matchadd('qfDiagError',    ' col \d\+ \+\zserror\>')
    call matchadd('qfDiagWarning',  ' col \d\+ \+\zswarning\>')
    call matchadd('qfDiagInfo',     ' col \d\+ \+\zsinfo\>')
    call matchadd('qfDiagHint',     ' col \d\+ \+\zshint\>')
    call matchadd('qfDiagSep',      l:sep)
endfunction

" Open the qflist with height = min(items, 10). Without an explicit height
" :copen leaves an already-open qf window at its previous size. Also closes
" any stale loclist window so we don't end up with two qf-style windows.
function! s:open_qflist_capped() abort
    let l:n = len(getqflist())
    if l:n == 0 | return | endif
    silent! lclose
    execute 'copen ' . min([l:n, 10])
endfunction

" quickfixtextfunc: render qf lines without the filename column, with
" lnum/col/type padded to their max widths across the whole list and a
" U+2502 vertical separator before the message. Used by
" helpers#open_diagnostics; the list is filtered to the current buffer so
" the filename would be the same on every line anyway.
function! helpers#qf_format_pathless(info) abort
    let l:list = a:info.quickfix
        \ ? getqflist({'id': a:info.id, 'items': 1})
        \ : getloclist(a:info.winid, {'id': a:info.id, 'items': 1})
    let l:items = l:list.items
    let l:names = {'E': 'error', 'W': 'warning', 'I': 'info', 'N': 'hint'}

    let l:max_lnum = 1
    let l:max_col  = 1
    let l:max_type = 0
    for l:it in l:items
        let l:max_lnum = max([l:max_lnum, strlen(string(l:it.lnum))])
        let l:max_col  = max([l:max_col,  strlen(string(l:it.col))])
        let l:type = get(l:names, toupper(l:it.type), l:it.type)
        let l:max_type = max([l:max_type, strlen(l:type)])
    endfor

    let l:sep = nr2char(0x2502)
    let l:fmt = printf('%%%dd col %%-%dd %%-%ds %s %%s',
        \ l:max_lnum, l:max_col, l:max_type, l:sep)

    let l:lines = []
    for l:i in range(a:info.start_idx - 1, a:info.end_idx - 1)
        let l:it = l:items[l:i]
        let l:type = get(l:names, toupper(l:it.type), l:it.type)
        call add(l:lines, printf(l:fmt,
            \ l:it.lnum, l:it.col, l:type, l:it.text))
    endfor
    return l:lines
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
