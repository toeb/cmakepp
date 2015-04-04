
function(project_state project_handle)
  set(new_state ${ARGN})
  if(new_state)
    project_state_change("${project_handle}" "${new_state}")
    ans(state)
  else()
    project_state_get("${project_handle}")
    ans(state)
  endif()
  return_ref(state)
endfunction()

