
function(project_state_assert project_handle)
  project_state_matches("${project_handle}" "${ARGN}")  
  ans(is_match)
  if(NOT is_match)
    message(FATAL_ERROR FORMAT "invalid project state (expected '${ARGN}' actual '{project_handle.project_descriptor.state}')")
  endif()
endfunction()
