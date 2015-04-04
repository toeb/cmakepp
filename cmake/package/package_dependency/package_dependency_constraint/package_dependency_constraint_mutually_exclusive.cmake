
function(package_dependency_constraint_mutually_exclusive
   dependency_problem 
  dependee_handle
  admissable_uri 
  dependency_constraint
  possible_dependencies
  )
  ## if dependency is not mutually_exclusive ignore
  map_tryget(${dependency_constraint} mutually_exclusive)
  ans(is_mutually_exclusive)
  if(NOT is_mutually_exclusive)
    return()
  endif()


  package_dependency_constraint_new("mutually_exclusive" "${dependee_handle}")
  ans(constraint)
  
  ## loop through all dependencies and add the mutual exclusitivity as a clause to the the cosntraint
  map_values(${possible_dependencies})
  ans(dependencies)
  set(current_dependencies ${dependencies})
  foreach(lhs ${dependencies})
    list(REMOVE_ITEM current_dependencies ${lhs})
    foreach(rhs ${current_dependencies})
      package_dependency_constraint_clause_new(
        ${constraint}
        "mutually exclusivivity" 
        "!${lhs}" "!${rhs}")
    endforeach()
  endforeach()

  return(${constraint})
endfunction()
