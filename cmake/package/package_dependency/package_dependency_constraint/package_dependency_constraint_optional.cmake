
function(package_dependency_constraint_optional
   dependency_problem 
  dependee_handle
  admissable_uri 
  dependency_constraint
  possible_dependencies)

  ## if constraint type is not optional ignore
  map_tryget(${dependency_constraint} constraint_type)
  ans(constraint_type)
  if(NOT "${constraint_type}_" STREQUAL "optional_")
    return()
  endif()


  package_dependency_constraint_new("optional" "${dependee_handle}")
  ans(constraint)

  return(${constraint})
endfunction()