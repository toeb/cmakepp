## `(<project handle> <materialization handle>)-><bool>`
## 
## checks wether an expected materialization actually exists and is valid
## return true if it is
function(package_materialization_check project_handle package_handle)
  ## if package does not have an materialization descriptor it is not materialized
  map_tryget(${package_handle} materialization_descriptor)
  ans(materialization_handle)
  if(NOT materialization_handle)
    return(false)
  endif()

  map_tryget(${materialization_handle} content_dir )
  ans(package_dir)

  map_tryget("${project_handle}" content_dir)
  ans(project_dir)

  path_qualify_from("${project_dir}" "${package_dir}")
  ans(content_dir)

  package_content_check("${package_handle}" "${content_dir}" )
  return_ans()
endfunction()
