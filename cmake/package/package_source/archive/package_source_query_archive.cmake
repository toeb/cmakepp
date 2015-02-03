
  ## 
  function(package_source_query_archive uri_string)
    uri("${uri_string}")
    ans(uri)

    ## uri needs to be local
    map_tryget(${uri} normalized_host)
    ans(host)
    if(NOT host STREQUAL "localhost")
      return()
    endif()

    ## get the local_path of the uri
    uri_to_localpath("${uri}")
    ans(local_path)

    path_qualify(local_path)

    ## check that file exists and is actually a archive
    archive_isvalid("${local_path}")
    ans(is_archive)

    if(NOT is_archive)
      return()
    endif()

    ## qualify uri to absolute path
    uri_qualify_local_path("${uri}")
    uri_format("${uri}")
    ans(package_uri)

    return_ref(package_uri)
  endfunction()
