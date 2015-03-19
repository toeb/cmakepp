## saves the project 
function(project_write project_handle)
  project_close("${project_handle}")
  ans(project_file)
  fwrite_data("${project_file}" "${project_handle}")
  return_ref(project_file)
endfunction() 