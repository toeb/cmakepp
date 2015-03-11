## `()->`
##
## performs the install operation which first optionally changes the dependencies and then materializes
function(project_install project_handle)
  set(args ${ARGN})
  project_change_dependencies(${project_handle} ${args})
  ans(changeset)
 

  project_materialize_dependencies(${project_handle})
  ans(changes_handles)
  
  return(${changeset})
endfunction()