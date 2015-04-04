
function(package_dependency_constraint_root_package
  dependency_problem 
  dependee_handle
  admissable_uri 
  dependency_constraint
  possible_dependencies)

  map_tryget(${dependency_constraint} constraint_type)
  ans(constraint_type)
  if(NOT "${constraint_type}" STREQUAL "package_constraint")
    return()
  endif()
  ## if root was not yet added and depndee is root package return a required constraint
  map_tryget(${dependency_problem} __root_handle_added)
  ans(__root_handle_added)

  if(__root_handle_added)
    return()
  endif() 



  map_tryget(${dependency_problem} root_handle)
  ans(root_handle)


  if(NOT "${dependee_handle}" STREQUAL "${root_handle}")
    return()
  endif()



  package_dependency_constraint_new("root_package" "${dependee_handle}")
  ans(constraint)

  package_dependency_constraint_clause_new(
    ${constraint}
    "root package is always required" 
    "${dependee_handle}")

  return(${constraint})
endfunction()