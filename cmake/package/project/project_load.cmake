## `(<project>)-><bool>`
##
## @TODO extract dfs algorithm, extreact dependency_load function which works for single dependencies
## 
## loads the specified project and its dependencies
##  
## **events**
## * `project_on_loading`
## * `project_on_loaded`
## * `project_on_package_loading`
## * `project_on_package_loaded`
## * `project_on_package_reload`
## * `project_on_package_cycle`
function(project_load project_handle)
  map_tryget(${project_handle} project_descriptor)
  ans(project_descriptor)

  ## load dependencies
  map_import_properties(${project_descriptor} package_materializations)
  map_values(package_materializations)
  ans(package_materializations)
  set(materialized_packages)
  map_tryget(${project_handle} content_dir)
  ans(project_dir)

  ## set content_dir for every package handle
  ## it is obtained by qualifying the materialization descriptors content_dir
  ## with the project's content_dir
  foreach(materialization ${package_materializations})
    map_tryget(${materialization} package_handle)
    ans_append(materialized_packages)
    ans(package_handle)
    map_tryget(${materialization} content_dir)
    ans(package_dir)
    path_qualify_from(${project_dir} ${package_dir})
    map_set(${package_handle} content_dir ${package_dir})
  endforeach()
  
  
  event_emit(project_on_loading ${project_handle})
  
  map_new()
  ans(context)
  function(__project_load_recurse)

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

          __project_load_recurse(${dependencies})
          
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
  __project_load_recurse(${project_handle} ${materialized_packages})

  event_emit(project_on_loaded ${project_handle})
 
  return(true)
endfunction()


