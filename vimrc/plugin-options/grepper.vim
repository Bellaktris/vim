let g:grepper = {
    \ 'tools': [ 'rg', 'ag', 'git', 'ack', 'grep' ],
    \
    \ 'git':           { 'grepprg':    'git grep -nI -i --fixed-strings'
                          \.' --ignore-case --exclude-standard --untracked ' },
    \
    \ 'ag':            { 'grepprg':    'ag --vimgrep'
                              \.' --smart-case --hidden --fixed-strings -- ' },
    \
    \ 'rg':            { 'grepprg':    'rg -H --no-heading --vimgrep'
                              \.' --smart-case --hidden --fixed-strings -- ' },
\}

command! -nargs=* FastGrep execute "Grepper -query ".helpers#shellescape('<args>')
