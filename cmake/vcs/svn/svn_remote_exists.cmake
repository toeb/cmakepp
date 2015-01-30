## returns true if a svn repository exists at the specified location
  function(svn_remote_exists uri)
    svn(ls "${uri}" --depth empty --return-code)
    ans(error)
    if(error)
      return(false)
    endif()
    return(true)
  endfunction()