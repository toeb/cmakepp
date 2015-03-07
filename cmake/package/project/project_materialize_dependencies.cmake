##
## 
## **events**
## * `on_dependencies_materialized(<project handle> <changeset>)`
function(project_materialize_dependencies project_handle)
  map_tryget(${project_handle} project_descriptor)
  ans(project_descriptor)
  map_tryget(${project_descriptor} installation_queue)
  ans(installation_queue)
  if(NOT installation_queue)
    return()
  endif()

  ## map union merges right to left
  ## so the newest overwrite the oldest changes
  map_new()
  ans(combined_changeset)
  map_union(${combined_changeset} ${installation_queue})

  map_tryget(${project_descriptor} package_cache)
  ans(package_cache)

  map_keys(${combined_changeset})
  ans(package_uris)

  foreach(package_uri ${package_uris})
    map_tryget(${combined_changeset} ${package_uri})
    ans(action)
    map_tryget(${package_cache} ${package_uri})
    ans(package_handle)
    if("${action}" STREQUAL "install")
        project_materialize(${project_handle} ${package_handle})
    elseif("${action}" STREQUAL "uninstall")
        project_dematerialize(${project_handle} ${package_handle})
    else()
      message(FATAL_ERROR "project_materialize dependencies: invalid action '${action}'")
    endif()

  endforeach() 
  ## clear installation queue
  map_set(${project_descriptor} installation_queue)

  ## emit event
  event_emit(project_on_dependencies_materialized ${project_handle} ${combined_changeset})

  ## load the project anew
  project_load(${project_handle})

endfunction()