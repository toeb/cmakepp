## package_source_query_webarchive(<~uri> [--package-handle] [--refresh] <args...>) -> <package uri...>
##
## if uri identifies a package the <package uri> is returned - else nothing is returned  
##
## queries the specified uri for a remote <archive> uses `download_cached` to
## download it. (else it would have to be downloaded multiple times)
##
##   
function(package_source_query_webarchive uri)
  set(args ${ARGN})


  list_extract_flag(args --package-handle)
  ans(return_package_handle)

  ## parse and format uri
  uri_coerce(uri)

  uri_check_scheme("${uri}" http? https?)
  ans(scheme_ok)

  if(NOT scheme_ok)
    return()
  endif()

  assign(uri_string = uri.uri)
  ## remove the last instance of the hash query - if it exists
  ## an edge case were this woudl fail is when another hash is meant
  ## a solution then would be to prepend the hash with a magic string 
  string(REGEX REPLACE "hash=[0-9A-Fa-f]+$" "" uri_string "${uri_string}")

  ## use download cached to download a package (pass along vars like --refresh)
  download_cached("${uri_string}" --readonly ${args})
  ans(path)

  if(NOT EXISTS "${path}")
    error("could not download ${uri_string}")
    return()
  endif()

  assign(expected_hash = uri.params.hash)

  package_source_query_archive("${path}?hash=${expected_hash}" --package-handle)
  ans(package_handle)

  if(NOT package_handle)
    error("specified file uri {uri.uri} is not a supported archive or hash mismatch")
    return()
  endif()

  assign(hash = package_handle.archive_descriptor.hash)


  uri_format("${uri}" "{hash:$hash}")
  ans(package_uri)

  if(NOT return_package_handle)
    return_ref(package_uri)
  endif()

  assign(package_handle.uri = package_uri )
  assign(package_handle.query_uri = uri.uri )
  assign(package_handle.resource_uri = uri_string)

  return_ref(package_handle)

endfunction()
