## package_source_resolve_directory(<~uri>) -> <package handle>
  function(package_source_resolve_directory uri)
    uri("${uri}")
    ans(uri)

    package_source_query_directory("${uri}")
    ans(valid_uri_string)

    list(LENGTH valid_uri_string count)
    if(NOT count EQUAL 1)
      return()
    endif()

    ## if uri contains query return
    map_tryget(${uri} query)
    ans(query)
    if(NOT "${query}_" STREQUAL "_")
      return()
    endif()

    this_get(directory)

    ## parse uri
    uri("${valid_uri_string}")
    ans(uri)

    map_tryget(${uri} scheme_specific_part)
    ans(subdir)

    set(content_dir "${directory}/${subdir}")

    package_handle("${content_dir}")
    ans(package_handle)

    map_tryget("${package_handle}" package_descriptor)
    ans(package_descriptor)

    map_defaults("${package_descriptor}" "{
      id:$subdir,
      version:'0.0.0'
    }")
    ans(package_descriptor)

    ## response
    map_new()
    ans(package_handle)
    map_set(${package_handle} package_descriptor "${package_descriptor}")
    map_set(${package_handle} uri "${valid_uri_string}")
    map_set(${package_handle} content_dir "${content_dir}")

    return_ref(package_handle)
  endfunction()
