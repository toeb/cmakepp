## `(<project handle>)-><path>`
##
## saves the project to the configure project file.
## the project will be closed after it was written.
## returns the path of the qualified file were the project was written to
function(project_write project_handle)
  project_close("${project_handle}")
  ans(project_file)
  fwrite_data("${project_file}" "${project_handle}")
  return_ref(project_file)
endfunction() 