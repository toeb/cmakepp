## `(<project handle>)-><materialization handle>...`
##
##
## **returns**
## * the `materialization handle`s of all changed packages
##
## **sideffects**
## * see `project_materialize`
## * see `project_dematerialize`
##
## **events**
## * `project_on_dependencies_materializing(<project handle>)`
## * `project_on_dependencies_materialized(<project handle>)`
## * events from `project_materialize` and project `project_dematerialize`
function(project_materialize_dependencies project_handle)
  map_tryget(${project_handle} project_descriptor)
  ans(project_descriptor)
  map_import_properties(${project_descriptor} 
    package_materializations
    dependency_configuration
    installation_queue
    package_cache
    )

  set(changed_packages)

  event_emit(project_on_dependencies_materializing ${project_handle})


  set(current_configuration ${dependency_configuration})
  while(true)
    list_pop_front(installation_queue)
    ans(new_configuration)
    if(NOT new_configuration)
      break()
    endif()
    package_dependency_configuration_changeset(${current_configuration} ${new_configuration})
    ans(changeset)


    map_keys(${changeset})
    ans(package_uris)
    foreach(package_uri ${package_uris})
      map_tryget(${dependency_configuration} ${package_uri})
      ans(state)

      map_tryget(${changeset} ${package_uri})
      ans(action)

      if("${action}" STREQUAL "install")
        project_materialize(${project_handle} ${package_uri})
        ans(package_handle)
      elseif("${action}" STREQUAL "uninstall")
        project_dematerialize(${project_handle} ${package_uri})
        ans(package_handle)
      else()
        message(FATAL_ERROR "project_materialize_dependencies: invalid action `${action}`")    
      endif()

      if(NOT package_handle)
        message(WARNING "failed to materialize/dematerialize dependency ${package_uri}")
      endif()

      list(APPEND changed_packages ${package_handle})
      
    endforeach() 

    #map_pop_front(${project_descriptor} installation_queue)
    map_set(project_descriptor dependency_configuration ${new_configuration})
    set(current_configuration ${new_configuration})
  endwhile()


  ## emit event
  event_emit(project_on_dependencies_materialized ${project_handle})

  ## load the project anew
  project_load(${project_handle})


  return_ref(changed_packages)
endfunction()