let b:surround_{char2nr("e")}
 \ = "\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}"
let b:surround_{char2nr("c")} = "\\\1command: \1{\r}"

nmap <silent><buffer> <plug>(view-compilation-status) :execute 'lcd '
      \.b:vimtex['root']<cr>:silent! VimtexErrors<cr>

setlocal conceallevel=0
setlocal concealcursor=nvic

setlocal foldenable

xmap <silent><buffer> ac <plug>(vimtex-ac)
omap <silent><buffer> ac <plug>(vimtex-ac)
xmap <silent><buffer> ic <plug>(vimtex-ic)
omap <silent><buffer> ic <plug>(vimtex-ic)
xmap <silent><buffer> ad <plug>(vimtex-ad)
omap <silent><buffer> ad <plug>(vimtex-ad)
xmap <silent><buffer> id <plug>(vimtex-id)
omap <silent><buffer> id <plug>(vimtex-id)
xmap <silent><buffer> ae <plug>(vimtex-ae)
omap <silent><buffer> ae <plug>(vimtex-ae)
xmap <silent><buffer> ie <plug>(vimtex-ie)
omap <silent><buffer> ie <plug>(vimtex-ie)
xmap <silent><buffer> a$ <plug>(vimtex-a$)
omap <silent><buffer> a$ <plug>(vimtex-a$)
xmap <silent><buffer> i$ <plug>(vimtex-i$)
omap <silent><buffer> i$ <plug>(vimtex-i$)

nmap <silent><buffer> % <plug>(vimtex-%)
xmap <silent><buffer> % <plug>(vimtex-%)
omap <silent><buffer> % <plug>(vimtex-%)
nmap <silent><buffer> ]] <plug>(vimtex-]])
xmap <silent><buffer> ]] <plug>(vimtex-]])
omap <silent><buffer> ]] <plug>(vimtex-]])
nmap <silent><buffer> ][ <plug>(vimtex-][)
xmap <silent><buffer> ][ <plug>(vimtex-][)
omap <silent><buffer> ][ <plug>(vimtex-][)
nmap <silent><buffer> [] <plug>(vimtex-[])
xmap <silent><buffer> [] <plug>(vimtex-[])
omap <silent><buffer> [] <plug>(vimtex-[])
nmap <silent><buffer> [[ <plug>(vimtex-[[)
xmap <silent><buffer> [[ <plug>(vimtex-[[)
omap <silent><buffer> [[ <plug>(vimtex-[[)

nmap <silent><buffer> <F7> <plug>(vimtex-cmd-create)
xmap <silent><buffer> <F7> <plug>(vimtex-cmd-create)
imap <silent><buffer> <F7> <plug>(vimtex-cmd-create)

imap <silent><buffer> ]]   <plug>(vimtex-delim-close)

nmap <silent><buffer> dse  <plug>(vimtex-env-delete)
nmap <silent><buffer> dsc  <plug>(vimtex-cmd-delete)
nmap <silent><buffer> ds$  <plug>(vimtex-env-delete-math)
nmap <silent><buffer> dsd  <plug>(vimtex-delim-delete)
nmap <silent><buffer> cse  <plug>(vimtex-env-change)
nmap <silent><buffer> csc  <plug>(vimtex-cmd-change)
nmap <silent><buffer> cs$  <plug>(vimtex-env-change-math)
nmap <silent><buffer> csd  <plug>(vimtex-delim-change-math)
nmap <silent><buffer> tsc  <plug>(vimtex-cmd-toggle-star)
nmap <silent><buffer> tse  <plug>(vimtex-env-toggle-star)
nmap <silent><buffer> tsd  <plug>(vimtex-delim-toggle-modifier)
xmap <silent><buffer> tsd  <plug>(vimtex-delim-toggle-modifier)

nmap <silent><buffer> <plug>(execute-file) :noa w<cr>:silent! VimtexCompile<cr>
nmap <silent><buffer> <plug>(view-file) :silent! VimtexView<cr>
