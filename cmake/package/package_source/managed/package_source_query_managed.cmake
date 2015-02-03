  ## package_source_query_managed(<~uri>) -> <uri string>
  ## 
  ## expects a this object to be defined which contains directory and source_name
  ## 
  function(package_source_query_managed uri)
    this_get(directory)
    this_get(source_name)

    uri("${uri}")
    ans(uri)




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
      file(GLOB index_files "${directory}/*/index.cmake")

      ## parse index_files
      set(indices)
      foreach(index ${index_files})
        qm_read("${index}")
        ans(package)
        list(APPEND indices "${package}")
      endforeach()


      map_isvalid("${query}")
      ans(ismap)
    
      ## query may be a * which returns all packages 
      ## or a regex /[regex]/
      ## or a map which will uses the properties to match values
      if(query STREQUAL "*")
        list_select_property(indices local_uri)
        ans(result)
      elseif("${query}" MATCHES "^/(.*)/$")
        set(regex "${CMAKE_MATCH_1}")
        set(result)
        foreach(package ${indices})
          map_tryget(${package} hash)
          ans(hash)
          if("${hash}" MATCHES ${regex})
            list(APPEND result "${source_name}:${hash}")
          endif()
        endforeach()
      elseif(ismap)
        ## todo
      endif()

    endif()
    ## return uris
    return_ref(result)
  endfunction()