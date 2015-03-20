  ## package_source_query_archive(<~uri>)->
  ## 
  function(package_source_query_archive uri)
    set(args ${ARGN})
        
    log("querying for local archive at {uri.uri}" --trace --function package_source_query_archive)

    list_extract_flag(args --package-handle)
    ans(return_package_handle)


    uri_coerce(uri)

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
        log("'{local_path}' is not an archive" --trace --function package_source_query_archive)
      return()
    endif()

    assign(expected_hash = uri.params.hash)
    ##
    checksum_file("${local_path}")
    ans(hash)


    if(NOT "${expected_hash}_" STREQUAL "_" AND NOT "${expected_hash}" STREQUAL "${hash}" )
        error("expected hash did not match hash of ${local_path}")
        return()
    endif()

    ## qualify uri to absolute path
    uri("${local_path}")
    ans(qualified_uri)
    uri_format("${qualified_uri}")
    ans(resource_uri)

    set(package_uri "${resource_uri}?hash=${hash}")
    log("found archive package at '{uri.uri}'" --function package_source_query_archive --trace)
    if(return_package_handle)
        set(package_handle)
        assign(!package_handle.uri = package_uri)
        assign(!package_handle.query_uri = uri.uri)
        assign(!package_handle.resource_uri = resource_uri)
        assign(!package_handle.archive_descriptor.hash = hash)
        assign(!package_handle.archive_descriptor.path = local_path)
        assign(!package_handle.archive_descriptor.pwd = pwd())
        return_ref(package_handle)
    endif()



    return_ref(package_uri)
  endfunction()
