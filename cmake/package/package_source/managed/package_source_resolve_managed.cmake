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

    return_ref(package_handle)


    return()

  endfunction()