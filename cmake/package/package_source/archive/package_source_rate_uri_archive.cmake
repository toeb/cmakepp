

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