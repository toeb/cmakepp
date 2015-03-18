
  function(package_source_query_metadata input_uri)
    set(args ${ARGN})
    uri_coerce(input_uri)
    list_extract_flag(args --package-handle)
    ans(return_package_handle)

    this_get(metadata)
    this_get(source_name)

    uri_check_scheme(${input_uri} "${source_name}?")
    ans(scheme_ok)
    if(NOT scheme_ok)
      return()
    endif()


    map_tryget(${input_uri} normalized_segments)
    ans(ids)
    if(NOT ids)
      return()
    endif()

    map_tryget(${metadata} ${ids})
    ans(package_descriptors)

    set(result)
    foreach(package_descriptor ${package_descriptors})
      map_import_properties(${package_descriptor} id version)
      map_tryget(${metadata} ${id})
      ans(current)
      if("${current}" STREQUAL "${package_descriptor}")
        set(uri "${source_name}:${id}")
      else()
        set(uri "${source_name}:${id}@${version}")
      endif()
      if(return_package_handle)
        map_tryget(${input_uri} uri)
        ans(query_uri)
        map_capture_new(uri query_uri package_descriptor)
        ans_append(result)
      else()
        list(APPEND result "${uri}")
      endif()
    endforeach()

    return_ref(result)



    if("${ids}" STREQUAL "*")
      map_keys(${metadata})
      ans(ids)
    endif()




    set(result)
    foreach(id ${ids})
      map_tryget("${metadata}" "${id}")
      ans(package_descriptor)

      if(package_descriptor)
        set(package_uri "${source_name}:${id}")
        if(NOT return_package_handle)
          list(APPEND result ${package_uri})
        else()
          map_clone_deep(${package_descriptor})
          ans(package_descriptor)
          set(package_handle)
          assign(!package_handle.uri = package_uri)
          assign(!package_handle.query_uri = uri.uri)
          assign(!package_handle.package_descriptor = package_descriptor)
          list(APPEND result ${package_handle})    
        endif()
      endif()
    endforeach()
    return_ref(result)
  endfunction()
