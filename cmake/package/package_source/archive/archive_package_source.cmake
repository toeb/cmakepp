##
##
##
function(archive_package_source)
  obj("{
    source_name:'archive',
    pull:'package_source_pull_archive',
    query:'package_source_query_archive',
    resolve:'package_source_resolve_archive',
    rate_uri:'package_source_rate_uri_archive'
  }")
  return_ans()
endfunction()



##
function(package_source_rate_uri_archive uri)
  uri_coerce(uri)
  uri_to_localpath("${uri}")
  ans(localpath)
  archive_isvalid("${localpath}")
  ans(isarchive)

  if(isarchive)
    return(999)
  endif()

  return(0)

endfunction()