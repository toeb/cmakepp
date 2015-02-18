
# checks wether the uri is a remote git repository
function(git_remote_exists uri)
  git_uri("${uri}")
  ans(uri)

  git(ls-remote "${uri}" --exit-code)
  ans(res)
  
  if("${res}" EQUAL 0)
    return(true)
  endif()
  return(false)
endfunction()