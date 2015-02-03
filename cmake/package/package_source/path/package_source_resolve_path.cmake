## returns a pacakge descriptor if the uri identifies a unique package
function(package_source_resolve_path uri)
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

    ## read pacakge descriptor and set default values
    json_read("${path}/package.cmake")
    ans(package_descriptor)

    map_tryget(${valid_uri} last_segment)
    ans(default_id)

    map_defaults("${package_descriptor}" "{id:$default_id,version:'0.0.0'}")
    ans(package_descriptor)

    ## response
    map_new()
    ans(result)
    map_set(${result} package_descriptor "${package_descriptor}")
    map_set(${result} content_dir "${path}")
    map_set(${result} uri "${valid_uri_string}")

    return(${result})
endfunction()
