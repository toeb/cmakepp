## `(<project package> <package handle>)-><void>` 
##
## updates all dependencies starting at package
## **sideffects**
## * 
## **events**
## * project_on_package_all_dependencies_materialized(<project handle> <package handle>)
## * project_on_package_and_all_dependencies_materialized(<project handle> <package handle>)
function(project_package_ready_state_update project package)

  function(__dodfs_update_recurse current)
    ## recursion anchor: current is already visted or still being visited
    map_tryget(${context} ${current})
    ans(status)
    if(status)
      return()
    endif()
    map_set(${context} ${current} visiting)

    map_get_map(${current} dependency_descriptor)
    ans(dependency_descriptor)
          
    ## check if all dependencies of package are materialized
    package_handle_is_ready(${current})
    ans(is_ready)

    map_tryget(${dependency_descriptor} is_ready)
    ans(was_ready)


    if(is_ready AND NOT was_ready)
      event_emit(project_on_package_ready ${project} ${current})
    elseif(NOT is_ready AND was_ready)
      event_emit(project_on_package_unready ${project} ${current})
    else()
      ## no change
      map_set(${context} ${current} visited)
      return()
    endif()

    ## update dependency descriptor
    map_set(${dependency_descriptor} is_ready ${is_ready})

    ## visit each dependee to check if their ready state changed
    map_tryget(${current} dependees)
    map_flatten(${__ans})
    map_flatten(${__ans})
    ans(dependees)

    foreach(dependee ${dependees})
      __dodfs_update_recurse(${dependee})
    endforeach()

    map_set(${context} ${current} visited)
    return()
  endfunction()

  map_new()
  ans(context)
  __dodfs_update_recurse(${package})
  return()
endfunction()

## register event handles to automatically call 
## update ready state function
function(__project_ready_state_register_listeners)
  event_addhandler(project_on_package_dematerialized project_package_ready_state_update)
  event_addhandler(project_on_package_materialized project_package_ready_state_update)
  event_addhandler(project_on_dependency_configuration_changed "[](project) project_package_ready_state_update({{project}} {{project}})")
endfunction()
task_enqueue(__project_ready_state_register_listeners)