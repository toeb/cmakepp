
##
## **events**
## * `project_on_loading`
## * `project_on_loaded`
## * `project_on_package_loading`
## * `project_on_package_loaded`
## * `project_on_package_reload`
## * `project_on_package_cycle`
function(project_load project_handle)
  ## load dependencies
  assign(materialized_package_map = project_handle.project_descriptor.materialized_packages)
  map_values(${materialized_package_map})
  ans(materialized_packages)  


  event_emit(project_on_loading ${project_handle})
  
  map_new()
  ans(context)
  function(load_recurse)

    foreach(package_handle ${ARGN})
      
      map_tryget(${context} ${package_handle})
      ans(state)
      if("${state}_" STREQUAL "visiting_")
        event_emit(project_on_package_cycle ${project_handle} ${package_handle})
      elseif("${state}_" STREQUAL "visited_")
        event_emit(project_on_package_reload ${project_handle} ${package_handle})
      else()
        map_set(${context} ${package_handle} visiting)
          
        ## pre order callback
        event_emit(project_on_package_loading ${project_handle} ${package_handle})
        set(parent_parent_package ${parent_package})
        set(parent_package ${package_handle})
        

        ## expand
        map_tryget(${package_handle} dependencies)
        ans(dependency_map)
        if(dependency_map)
          map_values(${dependency_map})
          ans(dependencies)

          load_recurse(${dependencies})
          
        endif()
        
        map_set(${context} ${package_handle} visited)

        ## post order callback
        set(parent_package ${parent_parent_package})
        event_emit(project_on_package_loaded ${project_handle} ${package_handle})

      endif()
    endforeach()
  endfunction()

  set(parent_parent_package)
  set(parent_package)
  load_recurse(${project_handle} ${materialized_packages})

  event_emit(project_on_loaded ${project_handle})
endfunction()


