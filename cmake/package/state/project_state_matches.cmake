

function(project_state_matches project_handle expected_state)
  project_state("${project_handle}")
  ans(actual_state)
  if("${actual_state}" MATCHES "${expected_state}")
    return(true)
  endif()
  return(false)
endfunction()
