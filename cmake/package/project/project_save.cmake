## saves the project 
## will unload the project and reload the project
function(project_save project_handle)
  project_close(${project_handle})
  ans(file)
  project_load(${project_handle})
  return_ref(file)
endfunction()