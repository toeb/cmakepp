## `(<project handle>)-><materialization handle>...`
##
## **events**
## * `project_on_package_materialization_missing`
##
## **sideffects**
## * removes missing materializations from `project_descriptor.package_materializations`
## * removes missing materializations from `package_handle.materialization_descriptor`
##
## checks all materializations of a project 
## if a materialization is missing it is removed from the 
## map of materializations
## returns all invalid materialization handles
function(project_materialization_check project_handle)
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
    ans(package_handle)
    package_materialization_check("${project_handle}" "${package_handle}")
    ans(ok)
    if(NOT ok)
      project_dematerialize("${project_handle}" "${package_uri}")    
      list(APPEND invalid_materializations ${package_handle})
    endif()
  endforeach()
  return_ref(invalid_materializations)
endfunction() 
