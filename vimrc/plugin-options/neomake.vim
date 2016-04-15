" vim:foldmethod=marker:foldmarker={{{,}}}:foldenable

if has('nvim')
    " Appearance {{{
    let g:neomake_error_sign = {
        \ 'text': '✘',
        \ 'texthl': 'SyntasticErrorSign',
    \ }

    let g:neomake_warning_sign = {
        \ 'text': '✘',
        \ 'texthl': 'SyntasticWarningSign',
    \ }

    let g:neomake_message_sign = {
        \ 'text': '!',
        \ 'texthl': 'SyntasticStyleErrorSign',
    \ }

    let g:neomake_informational_sign = {
        \ 'text': '·',
        \ 'texthl': 'SyntasticStyleWarningSign',
    \ }

    let s:neomake_filetypes = split(glob(g:vim_plug_dir
        \. '/neomake/autoload/neomake/makers/ft/*.vim'))

    let i = 0
    for ftype in s:neomake_filetypes
        let s:neomake_filetypes[i] = fnamemodify(ftype, ':t:r')
        let i = i + 1
    endfor

    sign define dummy

    function! s:OpenSignColumn()
        if index(s:neomake_filetypes, &ft) < 0 | return | endif
        execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
    endfunction

    let blacklisted_files = ['BUCK', 'TARGETS']

    augroup neomake_group | au!
        autocmd VimLeave * let g:neomake_verbose = 0
         autocmd FileType * call s:OpenSignColumn()
        autocmd BufEnter,BufWritePost *
          \ if helpers#is_small() != 0 && exists(":Neomake")
          \ && index(blacklisted_files, expand('%:t')) < 0
          \| execute "silent! Neomake" | endif
    augroup END
    " }}}

    " C++ {{{
    let g:neomake_cpp_clangcheck_maker = {
        \ 'exe': 'clang-check',
        \ 'args': ['-extra-arg-before=-std=c++1z',
        \          '-extra-arg-before=-I/usr/local/include/Eigen',
        \          '-extra-arg-before=-I'.expand('~').'/.files/c++/include'],
        \ 'errorformat':
            \ '%-G%f:%s:,' .
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%I%f:%l:%c: note: %m,' .
            \ '%f:%l:%c: %m,'.
            \ '%f:%l: %trror: %m,'.
            \ '%f:%l: %tarning: %m,'.
            \ '%I%f:%l: note: %m,'.
            \ '%-G%\m%\%%(LLVM ERROR:%\|No compilation database found%\)%\@!%.%#,' .
            \ '%f:%l: %m'
    \ }

    let g:neomake_cpp_clangtidy_maker = {
        \ 'exe': 'clang-tidy',
        \ 'args': ['-extra-arg-before=-std=c++1z',
        \          '-extra-arg-before=-I/usr/local/include/Eigen',
        \          '-extra-arg-before=-I'.expand('~').'/.files/c++/include'],
        \ 'errorformat':
            \ '%E%f:%l:%c: fatal error: %m,' .
            \ '%E%f:%l:%c: error: %m,' .
            \ '%W%f:%l:%c: warning: %m,' .
            \ '%-G%\m%\%%(LLVM ERROR:%\|No compilation database found%\)%\@!%.%#,' .
            \ '%E%m'
    \ }

    let g:neomake_c_clangcheck_maker = g:neomake_cpp_clangcheck_maker
    let g:neomake_c_clangtidy_maker = g:neomake_cpp_clangtidy_maker

    function! s:NeomakeCpplintPostProcess(entry)
        let a:entry.type = a:entry.type > 3 ? 'M' : 'I'
    endfunction

    let g:neomake_cpp_cpplint_maker = {
        \ 'exe': 'python3',
        \ 'args': ['-m', 'cpplint'],
        \ 'errorformat': '%A%f:%l:  %m [%t],%-G%.%#',
        \ 'postprocess': function('s:NeomakeCpplintPostProcess')
    \ }

    let g:neomake_c_cpplint_maker =
                \ deepcopy(g:neomake_cpp_cpplint_maker, 1)

    let g:neomake_c_cpplint_maker['args'] += [
                \'--filter=-readability/casting'
    \ ]

    let g:neomake_c_enabled_makers = []
    let g:neomake_cpp_enabled_makers = []

    if executable("cpplint")
        let g:neomake_c_enabled_makers += ['cpplint']
        let g:neomake_cpp_enabled_makers += ['cpplint']
    endif

    if executable('clang-tidy')
        let g:neomake_c_enabled_makers += ['clangtidy']
        let g:neomake_cpp_enabled_makers += ['clangtidy']
    endif

    if executable('clang-check')
        let g:neomake_c_enabled_makers += ['clangcheck']
        let g:neomake_cpp_enabled_makers += ['clangcheck']
    endif
    " }}}

    " Python {{{
    let g:neomake_python_exe = 'python3'

    let g:neomake_python_pylint_maker = {
        \ 'exe': g:neomake_python_exe,
        \ 'args': [
            \ '-m', 'pylint',
            \ '--output-format=text',
            \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}"',
            \ '--reports=no'
        \ ],
        \ 'errorformat':
            \ '%A%f:%l:%c:%t: %m,' .
            \ '%A%f:%l: %m,' .
            \ '%A%f:(%l): %m,' .
            \ '%-Z%p^%.%#,' .
            \ '%-G%.%#',
        \ 'postprocess': function('neomake#makers#ft#python#PylintEntryProcess')
    \ }

    let g:neomake_python_flake8_maker = {
        \ 'exe': g:neomake_python_exe,
        \ 'args': ['-m', 'flake8'],
        \ 'errorformat':
            \ '%E%f:%l: could not compile,%-Z%p^,' .
            \ '%A%f:%l:%c: %t%n %m,' .
            \ '%A%f:%l: %t%n %m,' .
            \ '%-G%.%#',
        \ 'postprocess': function('neomake#makers#ft#python#Flake8EntryProcess')
    \ }

    let g:neomake_python_enabled_makers = ['flake8', 'pylint']
    " }}}

    " Hack/PHP {{{
    if executable('hh_client')
        let g:neomake_php_hh_client_maker = {
            \ 'exe': 'hh_client',
            \ 'args': [
                  \ '--from', 'vim',
                  \ '--retries', '1',
                  \ '--retry-if-init', 'false'
            \ ],
            \ 'errorformat':
                \  '%EFile "%f"\, line %l\, characters %c-%.%#,%Z%m,'
                \ .'Error: %m,',
            \ 'postprocess': {
                \  entry -> entry.text =~# "([A-Z][a-z][a-z]*\[[0-9]*\])$"
                    \  ? entry : extend(entry, {'valid': -1})
            \  },
        \ }

        let g:neomake_php_enabled_makers = ['hh_client']
    endif
    " }}}
endif
