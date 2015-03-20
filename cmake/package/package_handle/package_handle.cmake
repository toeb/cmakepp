
  function(package_handle)
    map_tryget("${ARGN}" package_descriptor)
    ans(pd)
    map_tryget("${ARGN}" content_dir)
    ans(content_dir)

    path_qualify(content_dir)

    is_map("${pd}")
    ans(ismap)
    if(ismap AND content_dir AND IS_DIRECTORY "${content_dir}")
      return(${ARGN})
    endif()

    set(args ${ARGN})
    list_extract(args content_dir package_descriptor)

    path_qualify(content_dir)



    obj("${package_descriptor}")
    ans(pd)

    if(NOT pd)
      if(NOT IS_DIRECTORY "${content_dir}")
        return()
      endif()

      json_read("${content_dir}/package.cmake")
      ans(pd)
 
      if(NOT pd)
        return()
      endif()

    endif()


    map_new()
    ans(package_handle)
    map_set(${package_handle} package_descriptor ${pd})
    map_set(${package_handle} content_dir ${content_dir})
    return(${package_handle})

  endfunction()