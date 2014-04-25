function(git_remote_exists uri)
  git(ls-remote "${uri}" RESULT success)
  return(${success})
endfunction()