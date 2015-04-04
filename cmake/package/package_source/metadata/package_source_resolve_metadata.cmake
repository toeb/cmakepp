
  function(package_source_resolve_metadata uri)
    uri_coerce(uri)
    package_source_query_metadata("${uri}" --package-handle)
    ans(handles)

    list(LENGTH handles count)
    if(NOT "${count}" EQUAL 1)
      error("could not uniquely resolve {uri.uri} (got {count}) packages")
      return()
    endif()    
    return_ref(handles)
  endfunction()
