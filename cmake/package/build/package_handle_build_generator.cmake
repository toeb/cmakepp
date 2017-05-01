

  function(package_handle_build_generator package_handle)
    map_tryget(${package_handle} content_dir)
    ans(content_dir)

    map_tryget(${package_handle} generator)
    ans(generator)

    if(generator)
      return(${generator})
    endif()



    ## curretnly only know of a cmake generator
    if(EXISTS "${content_dir}/CMakeLists.txt")
      map_new()
      ans(gen)
      map_append(${gen} commands "shell>cmake -DCMAKE_INSTALL_PREFIX=\"@install_dir\" \"@content_dir\"")
      map_append(${gen} commands "shell>cmake --build . --target install --config @config")
      return(${gen})
    endif()


    return()

  endfunction()