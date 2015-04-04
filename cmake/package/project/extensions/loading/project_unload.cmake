## `(<project>)-><bool>`
##
## unloads the specified project and its dependencies
##  
## **events**
## * `project_on_unloading`  called before an packages is unloaded
## * `project_on_unloaded`  called after all packages were unloaded
## * `project_on_package_unloading` called before the package's dependencies are unloaded 
## * `project_on_package_unloaded` called after the package's dependencies are unloaded
function(project_unload project_handle)
  ## load dependencies
  map_import_properties(${project_handle} project_descriptor)
  map_import_properties(${project_descriptor} package_materializations)
  map_values(${package_materializations})
  ans(package_materializations)
  ans(package_handles)
  foreach(materialization ${package_materializations})
    map_tryget(${materialization} package_handle)
    ans_append(package_handles)
  endforeach()

  event_emit(project_on_unloading ${project_handle})
  
  map_new()
  ans(context)
  function(__project_unload_recurse)

    foreach(package_handle ${ARGN})
      
      map_tryget(${context} ${package_handle})
      ans(state)
      if("${state}_" STREQUAL "visiting_")
      elseif("${state}_" STREQUAL "visited_")
      else()
        map_set(${context} ${package_handle} visiting)
          
        ## pre order callback
        event_emit(project_on_package_unloading ${project_handle} ${package_handle})
        set(parent_parent_package ${parent_package})
        set(parent_package ${package_handle})
        

        ## expand
        map_tryget(${package_handle} dependencies)
        ans(dependency_map)
        if(dependency_map)
          map_values(${dependency_map})
          ans(dependencies)

          __project_unload_recurse(${dependencies})
          
        endif()
        
        map_set(${context} ${package_handle} visited)

        ## post order callback
        set(parent_package ${parent_parent_package})
        event_emit(project_on_package_unloaded ${project_handle} ${package_handle})

      endif()
    endforeach()
  endfunction()

  set(parent_parent_package)
  set(parent_package)
  __project_unload_recurse(${project_handle} ${package_handles})


  event_emit(project_on_unloaded ${project_handle})
 
  return(true)
endfunction()


