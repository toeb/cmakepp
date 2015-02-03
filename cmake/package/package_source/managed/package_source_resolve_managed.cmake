  ## package_source_resolve_managed(<~uri>) -> <package_handle>
  ##
  ## expects a var called this exist which contains the properties 'directory' and 'source_name'
  ## 
  function(package_source_resolve_managed uri)
    ## query for package uri
    package_source_query_managed("${uri}")
    ans(valid_uri_string)


    list(LENGTH valid_uri_string count)
    if(NOT count EQUAL 1)
      return()
    endif()

    ## if uri contains query return
    if("${uri}" MATCHES "\\?")
      return()
    endif()


    this_get(directory)

    ## parse uri
    uri("${valid_uri_string}")
    ans(uri)

    ## the scheme specific part is the hash (ie everything but the scheme)
    map_tryget(${uri} scheme_specific_part)
    ans(hash)

    set(managed_dir "${directory}/${hash}")

    ## read the index file in the correct folder (hash)
    ## if none exists then the uri is invalid
    qm_read("${managed_dir}/index.cmake")
    ans(index)

    if(NOT index)
      return()
    endif()

    ## read the package descriptor which is stored alongside the index
    qm_read("${managed_dir}/package.cmake")
    ans(package_descriptor)
    if(NOT package_descriptor)
      return()
    endif()

    ## get content dir from index (might not be a subdir if push --reference is used)
    map_tryget(${index} content_dir)
    ans(content_dir)

    ## generate response
    map_new()
    ans(response)
    map_set(${response} package_descriptor "${package_descriptor}")
    map_set(${response} uri "${valid_uri_string}")
    map_set(${response} content_dir "${content_dir}")
    map_set(${response} managed_dir "${managed_dir}")
    map_set(${response} index "${index}") ## also store the optional index 
    return_ref(response)
  endfunction()