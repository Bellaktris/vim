nmap <silent><buffer> g] m`:call hack#goto_def()<cr>
nmap <silent><buffer> g<c-]> m`:call hack#goto_def()<cr>
nmap <silent><buffer> gd m`:call hack#goto_def()<cr>
nmap <silent><buffer> gD m`:call hack#goto_def()<cr>

nmap <silent><buffer> <leader>ht :HackType<cr>

call helpers#setup_grep('tbgs')

nmap <silent><buffer> <leader>hpd Ohphpd_break();<esc>
