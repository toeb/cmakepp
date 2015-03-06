function(test)


  function(project_install_all)
    path("project.cmake")
    ans(config)
    
    if(NOT EXISTS "${config}")
      return()
    endif()

    cmake_read("${config}")
    ans(project_handle)
    
    default_package_source()
    ans(package_source)
    
    map_tryget(${package_source} dependency_configuration)
    ans(configuration)

    if(NOT configuration)
      message(FATAL_ERROR "no configuration")
    endif()

    map_keys(${configuration})
    ans(package_uris)

    foreach(package_uri ${package_uris})
      string_normalize("${package_uri}")
      ans(target)
      path_qualify(target)
      map_tryget(${configuration} ${package_uri})
      ans(pull)
      if(pull)
        if(NOT EXISTS "${target}")
      #    call(package_source.pull(${package_uri} ${target}))
        endif()
      else()
        if(EXISTS "${target}")
          rm(-r "${target}")
        endif()
      endif()
    endforeach()  

    return(${configuration})

  endfunction()


  function(project_update_dependencies)
  
    default_package_source()
    ans(package_source)
    path("project.cmake")
    ans(config)
    if(NOT EXISTS "${config}")
      map_new()
      ans(project_handle)
      map_set(${project_handle} uri project:root)
    else()
      cmake_read("${config}")
      ans(project_handle)
    endif()

    map_tryget(${project_handle} cache)
    ans(cache)
    if(NOT cache)
      map_new()
      ans(cache)
      map_set(${project_handle} cache ${cache})
    endif()



    project_handle_update_dependencies(
      ${package_source} 
      ${project_handle} 
      ${ARGN} 
      --cache ${cache}
    )
    ans(configuration)

    json_print(${configuration})
    map_set(${project_handle} dependency_configuration ${configuration})

    cmake_write("${config}" ${project_handle})
    return()
  endfunction()


endfunction()