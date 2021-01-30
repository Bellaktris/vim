if exists(':Alias')
  command! -nargs=*       GitStatus exec 'lcd '.helpers#find_git_root() | Gstatus <args>
  call Alias(0, 'gstatus', 'GitStatus')

  command! -nargs=*       Gdiff    exec 'lcd '.helpers#find_git_root() | Gdiff <args>
  call Alias(0, 'gdiff', 'Gdiff')

  command! -nargs=*       GitCommit exec 'lcd '.helpers#find_git_root() | Gcommit <args>
  call Alias(0, 'gcommit', 'GitCommit')

  command! -nargs=*       GitWrite  exec 'lcd '.helpers#find_git_root() | Gwrite <args>
  call Alias(0, 'gwrite', 'GitWrite')

  command! -nargs=* -bang GitMain   exec 'lcd '.helpers#find_git_root() | Git<bang> <args>
  call Alias(0, 'git', 'GitMain')

  command! -nargs=*       GitCd     exec 'lcd '.helpers#find_git_root() | Gcd <args>
  call Alias(0, 'gcd', 'GitCd')

  command! -nargs=*       GitLCd    exec 'lcd '.helpers#find_git_root() | Glcd <args>
  call Alias(0, 'glcd', 'GitLCd')

  command! -nargs=* -bang GitGrep   exec 'lcd '.helpers#find_git_root() | Ggrep<bang> <args>
  call Alias(0, 'ggrep', 'GitGrep')

  command! -nargs=*       GitLog    exec 'lcd '.helpers#find_git_root() | Glog <args>
  call Alias(0, 'glog', 'GitLog')

  command! -nargs=*       GitPush   exec 'lcd '.helpers#find_git_root() | Gpush <args>
  call Alias(0, 'gpush', 'GitPush')

  command! -nargs=*       GitPull   exec 'lcd '.helpers#find_git_root() | Gpull <args>
  call Alias(0, 'gpull', 'GitPull')
endif
