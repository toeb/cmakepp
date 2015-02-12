  ## package_source_query_managed(<~uri>) -> <uri string>
  ## 
  ## expects a this object to be defined which contains directory and source_name
  ## 
  function(package_source_query_managed uri)
    set(args ${ARGN})


    list_extract_flag(args --package-handle)
    ans(return_package_handle)

    this_get(directory)
    this_get(source_name)

    uri_coerce(uri)

    ### read all package handles (new objects)
    ### also set the query_uri field
    file(GLOB package_handle_files "${directory}/*/package_handle.qm")
    set(package_handles)

    ## this is slow and may be made faster
    foreach(package_handle_file ${package_handle_files})
      qm_read("${package_handle_file}")
      ans(package_handle)
      assign(package_handle.query_uri = uri.uri)
      list(APPEND package_handles ${package_handle})
    endforeach()


    ## filter package handles by query
    package_handle_filter(package_handles "${uri}")
    ans(filtered_handles)

    if(NOT return_package_handle)
      set(package_uris)
      foreach(package_handle ${filtered_handles})
        map_tryget(${package_handle} uri)
        ans(uri)
        list(APPEND package_uris ${uri})
      endforeach()
      return_ref(package_uris)
    else()
      return_ref(filtered_handles)
    endif() 


    return()
  endfunction()