# returns true iff the uri is a hg repository
function(hg_remote_exists uri)
  hg(identify "${uri}" --result)
  ans(result)
  map_tryget(${result} result)
  ans(error)

  if(NOT error)
    return(true)
  endif()
  return(false)
endfunction()
