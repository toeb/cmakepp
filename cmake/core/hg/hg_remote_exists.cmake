# returns true iff the uri is a hg repository
function(hg_remote_exists uri)
  hg(identify "${uri}" --result)
  ans(result)
  map_tryget(${result} result)
  ans(return_code)

  if(NOT return_code)
    return(true)
  endif()
  return(false)
endfunction()
