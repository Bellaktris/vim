if exists(':Alias')
  command! -nargs=*       GitStatus exec 'lcd '.helpers#find_git_root() | Gstatus <args>
  Alias gstatus GitStatus

  command! -nargs=*       Gdiff    exec 'lcd '.helpers#find_git_root() | Gdiff <args>
  Alias gdiff Gdiff

  command! -nargs=*       GitCommit exec 'lcd '.helpers#find_git_root() | Gcommit <args>
  Alias gcommit GitCommit

  command! -nargs=*       GitWrite  exec 'lcd '.helpers#find_git_root() | Gwrite <args>
  Alias gwrite GitWrite

  command! -nargs=* -bang GitMain   exec 'lcd '.helpers#find_git_root() | Git<bang> <args>
  Alias git GitMain

  command! -nargs=*       GitCd     exec 'lcd '.helpers#find_git_root() | Gcd <args>
  Alias gcd GitCd

  command! -nargs=*       GitLCd    exec 'lcd '.helpers#find_git_root() | Glcd <args>
  Alias glcd GitLCd

  command! -nargs=* -bang GitGrep   exec 'lcd '.helpers#find_git_root() | Ggrep<bang> <args>
  Alias ggrep GitGrep

  command! -nargs=*       GitLog    exec 'lcd '.helpers#find_git_root() | Glog <args>
  Alias glog GitLog

  command! -nargs=*       GitPush   exec 'lcd '.helpers#find_git_root() | Gpush <args>
  Alias gpush GitPush

  command! -nargs=*       GitPull   exec 'lcd '.helpers#find_git_root() | Gpull <args>
  Alias gpull GitPull
endif
