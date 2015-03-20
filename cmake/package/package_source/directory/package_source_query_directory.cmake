  ## package_source_query_directory(<~uri>) -> <uri string>
  function(package_source_query_directory uri)
    set(args ${ARGN})

    list_extract_flag(args --package-handle)
    ans(return_package_handle)

    this_get(directory)
    this_get(source_name)

    uri_coerce(uri)

    ## return if scheme is either empty or equal to source_name       
    assign(scheme = uri.scheme)

    uri_check_scheme("${uri}" "${source_name}?")
    ans(scheme_ok)
    if(NOT scheme_ok)
      error("expected either ${source_name} or nothing as scheme. {uri.uri}")
      return()
    endif() 

    map_tryget(${uri} segments)
    ans(segments)
    list(LENGTH segments segment_length)

    ## if uri has a single segment it is interpreted as a hash
    if(segment_length EQUAL 1 AND IS_DIRECTORY "${directory}/${segments}")
      set(result "${source_name}:${segments}")
    elseif(NOT segment_length EQUAL 0)
      ## multiple segments are not allowed and are a invliad uri
      set(result)
    else()
      ## else parse uri's query (uri starts with ?)

      map_tryget(${uri} query)
      ans(query)
      if("${query}" MATCHES "=")
        ## if query contains an equals it is a map
        ## else it is a value
        map_tryget(${uri} params)
        ans(query)        
      endif()

      ## empty query returns nothing
      if(query STREQUAL "")
        return()
      endif()

      ## read all package indices
      file(GLOB folders RELATIVE "${directory}" "${directory}/*")

      is_map("${query}")
      ans(ismap)
    
      ## query may be a * which returns all packages 
      ## or a regex /[regex]/
      ## or a map which will uses the properties to match values
      if(query STREQUAL "*")
        set(result)
        foreach(folder ${folders})
          list(APPEND result "${source_name}:${folder}")
        endforeach()
      elseif("${query}" MATCHES "^/(.*)/$")
        ## todo
        set(result)
      elseif(ismap)
        ## todo
        set(result)
      endif()
    endif()

    if(return_package_handle)
      set(package_handles)
      foreach(item ${result})
        set(package_handle)
        assign(!package_handle.uri = item)
        assign(!package_handle.query_uri = uri.uri)
        list(APPEND package_handles ${package_handle})
      endforeach()
      set(result ${package_handles})
    endif()

    return_ref(result)

  endfunction()

