# checks wether the uri is a remote git repository
function(git_remote_exists uri)
  git(ls-remote "${uri}" --return-code)
  ans(res)
  if("${res}" EQUAL 0)
    return(true)
  endif()
  return(false)
endfunction()