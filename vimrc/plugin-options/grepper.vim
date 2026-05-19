if executable('rg') || executable('ag')
  let g:grep_opts = ''
elseif executable('git')
  let g:grep_opts = '-F'
elseif executable('ack')
  let g:grep_opts = '-Q'
else
  let g:grep_opts = ''
endif

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
