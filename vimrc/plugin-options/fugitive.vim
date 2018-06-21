if exists(':Alias')
  command! -nargs=*       GitStatus exec 'lcd '.helpers#find_git_root() | Gstatus <args>
  call CmdAlias('gstatus', 'GitStatus')

  command! -nargs=*       Gdiff    exec 'lcd '.helpers#find_git_root() | Gdiff <args>
  call CmdAlias('gdiff', 'Gdiff')

  command! -nargs=*       GitCommit exec 'lcd '.helpers#find_git_root() | Gcommit <args>
  call CmdAlias('gcommit', 'GitCommit')

  command! -nargs=*       GitWrite  exec 'lcd '.helpers#find_git_root() | Gwrite <args>
  call CmdAlias('gwrite', 'GitWrite')

  command! -nargs=* -bang GitMain   exec 'lcd '.helpers#find_git_root() | Git<bang> <args>
  call CmdAlias('git', 'GitMain')

  command! -nargs=*       GitCd     exec 'lcd '.helpers#find_git_root() | Gcd <args>
  call CmdAlias('gcd', 'GitCd')

  command! -nargs=*       GitLCd    exec 'lcd '.helpers#find_git_root() | Glcd <args>
  call CmdAlias('glcd', 'GitLCd')

  command! -nargs=* -bang GitGrep   exec 'lcd '.helpers#find_git_root() | Ggrep<bang> <args>
  call CmdAlias('ggrep', 'GitGrep')

  command! -nargs=*       GitLog    exec 'lcd '.helpers#find_git_root() | Glog <args>
  call CmdAlias('glog', 'GitLog')

  command! -nargs=*       GitPush   exec 'lcd '.helpers#find_git_root() | Gpush <args>
  call CmdAlias('gpush', 'GitPush')

  command! -nargs=*       GitPull   exec 'lcd '.helpers#find_git_root() | Gpull <args>
  call CmdAlias('gpull', 'GitPull')
endif
