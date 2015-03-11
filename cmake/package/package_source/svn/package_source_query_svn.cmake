##
##
##
function(package_source_query_svn uri)
  set(args ${ARGN})
  list_extract_flag(args --package-handle)
  ans(return_package_handle)

  uri_coerce(uri)  

  svn_uri_analyze("${uri}")
  ans(svn_uri)

  svn_uri_format_ref("${svn_uri}")
  ans(ref_uri)

  svn_remote_exists("${ref_uri}")
  ans(remote_exists)

  if(NOT remote_exists)
    return()
  endif()

  svn_uri_format_package_uri("${svn_uri}")
  ans(package_uri)

  set(package_uri "svnscm+${package_uri}")

  if(return_package_handle)
    map_new()
    ans(package_handle)
    map_set(${package_handle} uri ${package_uri})
    assign(package_handle.query_uri = uri.uri)

    return(${package_handle})
  endif()

  return(${package_uri})

endfunction()