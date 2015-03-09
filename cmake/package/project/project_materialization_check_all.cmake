## `(<project handle>)-><materialization handle>...`
##
## checks all materializations of a project 
## if a materialization is missing it is removed from the 
## map of materializations
## returns all invalid materialization handles
function(project_materialization_check_all project_handle)
  map_import_properties(${project_handle} project_descriptor)
  map_import_properties(${project_descriptor} package_materializations)

  if(NOT package_materializations)
    return()
  endif()
  map_keys(${package_materializations})
  ans(package_uris)

  set(invalid_materializations)
  foreach(package_uri ${package_uris})
    map_tryget("${package_materializations}" "${package_uri}")
    ans(materialization_handle)
    project_materialization_check("${project_handle}" "${materialization_handle}")
    ans(ok)
    if(NOT ok)
      list(APPEND invalid_materializations ${materialization_handle})
      map_remove("${package_materializations}" "${package_uri}")
    endif()
  endforeach()
  return_ref(invalid_materializations)
endfunction() 
