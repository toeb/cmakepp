## package_source_query_webarchive(<~uri> <args...>) -> <package uri...>
##
## if uri identifies a package the <package uri> is returned - else nothing is returned  
##
## queries the specified uri for a remote <archive> uses `download_cached` to
## download it. (else it would have to be downloaded multiple times)
##
##   
function(package_source_query_webarchive uri)
  set(args ${ARGN})

  ## parse and format uri
  uri("${uri}")
  ans(uri)

  uri_format("${uri}")
  ans(uri_string)

  ## use download cached to download a package (pass along vars like)
  download_cached("${uri_string}" --readonly ${args})
  ans(path)

  ## check if file is an archive
  archive_isvalid("${path}")
  ans(is_archive)

  if(NOT is_archive)
    return()
  endif()

  return("${uri_string}")

endfunction()
