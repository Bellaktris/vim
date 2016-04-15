nmap <silent><buffer> g] m`:call hack#goto_def()<cr>
nmap <silent><buffer> g<c-]> m`:call hack#goto_def()<cr>
nmap <silent><buffer> gd m`:call hack#goto_def()<cr>
nmap <silent><buffer> gD m`:call hack#goto_def()<cr>

nmap <silent><buffer> <leader>ht :HackType<cr>

" noremap <silent><buffer> <leader>rf :call hack#find_refs()<cr>

if executable('tbgs')
  xmap <silent> <leader>ag y:execute "lcd ".helpers#find_git_root()<cr>
      \ :exe "Grepper -noprompt -grepprg tbgs -i -s "
      \ . helpers#shellescape(substitute(@0, '--', '', 'g'))<cr>

  command! -nargs=* FastGrep execute "Grepper -noprompt -grepprg tbgs -i -s ".helpers#shellescape('<args>')
endif  " executable('tbgs')

nmap <silent><buffer> <leader>hpd Ohphpd_break();<esc>
