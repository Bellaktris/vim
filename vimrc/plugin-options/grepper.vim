let g:grepper = {
    \ 'tools': [ 'rg', 'ag', 'git', 'ack', 'grep' ],
    \
    \ 'git':           { 'grepprg':    'git grep -nI -i --fixed-strings'
                          \.' --ignore-case --exclude-standard --untracked ' },
    \
    \ 'ag':            { 'grepprg':    'ag --vimgrep --silent'
                              \.' --smart-case --hidden --fixed-strings -- ' },
    \
    \ 'rg':            { 'grepprg':    'rg -H --no-heading --vimgrep --no-messages'
                              \.' --smart-case --hidden --fixed-strings -- ' },
\}

function! FastGrepFirstRoot(line, opts)
    " let l:current_dir = getcwd()
    execute 'lcd ' . helpers#find_git_root()
    execute "Grepper -query " . a:opts . ' ' . helpers#shellescape(a:line)
    " execute 'lcd ' . l:current_dir
endfunction

function! FastGrepLastRoot(line, opts)
    " let l:current_dir = getcwd()
    let l:first_root = helpers#find_git_root()
    let l:last_root = helpers#find_last_root()

    if l:first_root != l:last_root
        execute 'lcd ' . l:last_root
    else
        execute "cd " . expand("%:p:h")
    endif
    execute "Grepper -query " . a:opts . ' ' . helpers#shellescape(a:line)
    " execute 'lcd ' . l:current_dir
endfunction

command! -nargs=* FastGrepU call FastGrepFirstRoot('<args>', '')
command! -nargs=* FastGrepL call FastGrepLastRoot('<args>', '')
