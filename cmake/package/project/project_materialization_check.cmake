## `(<project handle> <materialization handle>)-><bool>`
## 
## checks wether an expected materialization actually exists and is valid
## return true if it is
function(project_materialization_check project_handle materialization_handle)
  map_import_properties(${materialization_handle} content_dir package_handle)
  map_tryget("${project_handle}" content_dir)
  ans(project_dir)
  path_qualify_from("${project_dir}" "${content_dir}")
  ans(content_dir)
  if(NOT EXISTS "${content_dir}")
    return(false)
  endif()
  return(true)
endfunction()

