## creates the dependency required cosntraint for the specified dependee
function(package_dependency_constraint_required
  dependency_problem 
  dependee
  admissable_uri 
  dependency_constraint
  possible_dependencies
  )
  
  ## if constraint_type is not required ignore
  map_tryget(${dependency_constraint} constraint_type)
  ans(type)
  if(NOT "${type}" STREQUAL "required")
    return()
  endif()

  map_values(${possible_dependencies})
  ans(dependencies)

  package_dependency_constraint_new("required" "${dependee}")
  ans(constraint)

  ## either depndee is not installed 
  set(clause "!${dependee}")
  foreach(dependency ${dependencies})
    ## or one of the dependencies is installed
    list(APPEND clause "${dependency}")
  endforeach()


  package_dependency_constraint_clause_new(
    ${constraint}
    "{dependee.uri} => {admissable_uri} requires one of {possible_dependencies.__keys__}" 
    ${clause})


  return(${constraint})
endfunction()