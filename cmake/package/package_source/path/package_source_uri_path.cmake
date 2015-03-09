## `()`
##
## returns full rating if 
## dir/package.cmake exists 
## and a very high rating for a directory 
## else it returns 0
function(package_soure_rate_uri_path uri)
  uri_coerce(uri)
  uri_to_localpath("${uri}")
  ans(localpath)
  if(EXISTS "${localpath}/package.cmake")
    return(999)
  endif()
  if(IS_DIRECTORY "${localpath}")
    return(998)
  endif()
  path_qualify(localpath)
  if(EXISTS "${localpath}")
    return(500)
  endif()
  return(0)
endfunction()