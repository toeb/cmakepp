## returns a pacakge descriptor if the uri identifies a unique package
function(package_source_resolve_path uri)
    uri("${uri}")
    ans(uri)

    package_source_query_path("${uri}" --package-handle)
    ans(package_handle)

    list(LENGTH package_handle count)
    if(NOT "${count}" EQUAL 1)
        error("could not find a unique immutbale uri for {uri.uri}")
        return()
    endif()


    return_ref(package_handle)


    ## get valid uris by querying ensure that only a single uri is found
    package_source_query_path("${uri}")
    ans(valid_uri_string)

    list(LENGTH valid_uri_string package_count)
    if(NOT "${package_count}" EQUAL 1)
      return()
    endif()

    ## generate uri object and get local path
    uri("${valid_uri_string}")
    ans(valid_uri)

    uri_to_localpath("${valid_uri}")
    ans(path)

    ## read package descriptor and set default values
    package_handle("${path}")
    ans(package_handle)

    map_tryget("${package_handle}" package_descriptor)
    ans(package_descriptor)

    map_tryget(${valid_uri} last_segment)
    ans(default_id)

    map_defaults("${package_descriptor}" "{id:$default_id,version:'0.0.0'}")
    ans(package_descriptor)

    ## response
    map_new()
    ans(package_handle)
    map_set(${package_handle} package_descriptor "${package_descriptor}")
    map_set(${package_handle} content_dir "${path}")
    map_set(${package_handle} uri "${valid_uri_string}")

    return(${package_handle})
endfunction()
