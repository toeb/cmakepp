## `()`
##
## **events**:
## * `project_on_package_dematerializing(<project handle> <package handle>)`
## * `project_on_package_dematerialized(<project handle> <package handle>)`
function(project_dematerialize project_handle package_handle)
  map_tryget(${project_handle} project_descriptor)
  ans(project_descriptor)

  map_tryget(${package_handle} uri)
  ans(package_uri)

  map_tryget(${project_descriptor} package_materializations)
  ans(package_materializations)

  map_tryget(${package_materializations} ${package_uri})
  ans(package_materialization_handle)

  if(NOT package_materialization_handle)
    message(FORMAT "project_dematerialize: package was not installed: '${package_uri}'")
    return(false)
  endif() 

  event_emit(project_on_package_dematerializing ${project_handle} ${package_handle})

  map_tryget(${project_handle} content_dir)
  ans(project_dir)

  map_tryget(${package_materialization_handle} content_dir)
  ans(package_dir)

  path_qualify_from(${project_dir} ${package_dir})
  ans(package_dir)

  map_remove(${package_materializations} ${package_uri})

  if("${project_dir}" STREQUAL "${package_dir}")
    message(WARNING "project_dematerialize: package dir is project dir will not delete")
    return(false) 
  endif()


  rm(-r "${package_dir}")

  event_emit(project_on_package_dematerialized ${project_handle} ${package_handle})

  return(true)  
endfunction()
