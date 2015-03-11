
  function(pkg_inst)
    pkg_load()
    ans(project_handle)
    
    default_package_source()
    ans(package_source)
    
    map_tryget(${project_handle} dependency_configuration)
    ans(configuration)

    if(NOT configuration)
      return()
    endif()

    map_keys(${configuration})
    ans(package_uris)

    map_tryget(${project_handle} uri)
    ans(uri)
    list_remove(package_uris ${uri})
    foreach(package_uri ${package_uris})
      string_normalize("${package_uri}")
      ans(target)
      path_qualify(target)
      map_tryget(${configuration} ${package_uri})
      ans(pull)
      if(pull)
        if(NOT EXISTS "${target}")
          message("installing ${package_uri} to ${target}")
          #mkdir("${target}")
          call(package_source.pull(${package_uri} ${target}))
        endif()
      else()
        if(EXISTS "${target}")
          message("deleting ${package_uri} from ${target}")
          
          rm(-r "${target}")
        endif()
      endif()
    endforeach()  

    return(${configuration})

  endfunction()

function(pkg_load)
  path("project.cmake")
  ans(config)
  if(NOT EXISTS "${config}")
    map_new()
    ans(project_handle)
  else()
    cmake_read("${config}")
    ans(project_handle)
  endif()
  map_tryget(${project_handle} uri)
  ans(uri)
  if(NOT uri)
    map_set(${project_handle} uri project:root)

  endif()

  return_ref(project_handle)

endfunction()
function(pkg_save)
  cmake_write("project.cmake" ${project_handle})

endfunction()

function(pkg_dep)
  set(args ${ARGN})
  default_package_source()
  ans(package_source)
  pkg_load()
  ans(project_handle)
 
  project_update_dependencies(${package_source} ${project_handle} ${args})
  ans(res)
 
  pkg_save(${project_handle})
  return_ref(res)
endfunction()


  function(project_update_dependencies package_source project_handle)

    map_tryget(${project_handle} cache)
    ans(cache)
    if(NOT cache)
      map_new()
      ans(cache)
      map_set(${project_handle} cache ${cache})
    endif()


    map_tryget(${project_handle} dependency_configuration)
    ans(previous_configuration)
    if(NOT previous_configuration)
      map_new()
      ans(previous_configuration)
    endif()

    package_dependency_configuration_update(
      ${package_source} 
      ${project_handle} 
      ${ARGN} 
      --cache ${cache}
    )
    ans(configuration)
    map_set(${project_handle} dependency_configuration ${configuration})

    package_dependency_configuration_changeset(${previous_configuration} ${configuration})
    ans(res)


    return_ref(res)
  endfunction()
