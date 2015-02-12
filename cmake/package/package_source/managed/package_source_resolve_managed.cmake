  ## package_source_resolve_managed(<~uri>) -> <package_handle>
  ##
  ## expects a var called this exist which contains the properties 'directory' and 'source_name'
  ## 
  function(package_source_resolve_managed uri)
    uri_coerce(uri)
    ## query for package uri
    package_source_query_managed("${uri}" --package-handle)
    ans(package_handle)


    list(LENGTH package_handle count)
    if(NOT "${count}" EQUAL 1)
      return()
    endif()

    ## if uri contains query return
    if("${uri}" MATCHES "\\?")
      return()
    endif()


    this_get(directory)

    assign(managed_dir = package_handle.managed_descriptor.index.location)    
    ## read the index file in the correct folder (hash)
    ## if none exists then the uri is invalid
    qm_read("${managed_dir}/index.cmake")
    ans(index)

    if(NOT index)
      error("invalid managed dir - data is corrupted missing index file")
      return()
    endif()

    ## read the package descriptor which is stored alongside the index
    qm_read("${managed_dir}/package.cmake")
    ans(package_descriptor)
    if(NOT package_descriptor)
      return()
    endif()

    map_set(${package_handle} package_descriptor "${package_descriptor}")
    assign(package_handle.content_dir = package_handle.managed_descriptor.index.content_dir)
    return_ref(package_handle)
  endfunction()