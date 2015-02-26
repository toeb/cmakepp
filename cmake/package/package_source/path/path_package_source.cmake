##
##
##
function(path_package_source)
  obj("{
    source_name:'file',
    pull:'package_source_pull_path',
    push:'package_source_push_path',
    query:'package_source_query_path',
    resolve:'package_source_resolve_path',
    rate_uri:'package_soure_rate_uri_path'
  }")
  return_ans()
endfunction()

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
  return(0)
endfunction()