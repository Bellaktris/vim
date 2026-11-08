" Lowercase aliases that cd to the repository root first.  They call fugitive's
" current commands: :Gstatus, :Gcommit, :Gpush, :Gpull, :Glog and :Gdiff only
" exist with g:fugitive_legacy_commands set, or not at all.
if exists(':Alias')
  command! -nargs=*       GitStatus exec 'lcd '.helpers#find_git_root() | Git <args>
  call Alias(0, 'gstatus', 'GitStatus')

  command! -nargs=*       GitDiff   exec 'lcd '.helpers#find_git_root() | Gdiffsplit <args>
  call Alias(0, 'gdiff', 'GitDiff')

  command! -nargs=*       GitCommit exec 'lcd '.helpers#find_git_root() | Git commit <args>
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

  command! -nargs=*       GitLog    exec 'lcd '.helpers#find_git_root() | Gclog <args>
  call Alias(0, 'glog', 'GitLog')

  command! -nargs=*       GitPush   exec 'lcd '.helpers#find_git_root() | Git push <args>
  call Alias(0, 'gpush', 'GitPush')

  command! -nargs=*       GitPull   exec 'lcd '.helpers#find_git_root() | Git pull <args>
  call Alias(0, 'gpull', 'GitPull')
endif
