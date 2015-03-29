
function(package_dependency_constraint_incompatible
  dependency_problem 
  dependee
  admissable_uri 
  dependency_constraint
  possible_dependencies
  )
  
  ## ignore constraints which are not "incompatible" type
  map_tryget(${dependency_constraint} constraint_type)
  ans(constraint_type)

  if(NOT "${constraint_type}" STREQUAL "incompatible")
    return()
  endif()


  package_dependency_constraint_new("incompatible" "${dependee}")
  ans(constraint)

  map_values(${possible_dependencies})
  ans(dependencies)
  foreach(dependency ${dependencies})
    package_dependency_constraint_clause_new(
      ${constraint}
      "'{dependee.uri}' is incompatible with '{dependency.uri}'" 
      "!${dependee}" "!${dependency}")
  endforeach()

  return(${constraint})
endfunction()