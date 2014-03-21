function(git_remote_exists result uri)
  git(ls-remote "${uri}" RESULT success)
  return_value(${success})
endfunction()