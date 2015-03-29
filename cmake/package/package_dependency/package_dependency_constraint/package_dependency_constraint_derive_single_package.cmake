## `(<clauses:<sequence>> <dependee_handle:<package handle>>)-><void>`
##
##
## adds depdency clauses resulting from dependee handle to the 
## clauses sequence.  Currently only supports  
##
## **currently only supports true, false and "" constraints**
function(package_dependency_constraint_derive_single_package dependency_problem dependee_handle)

  map_tryget(${dependee_handle} dependencies)
  ans(dependencies)

  map_tryget(${dependee_handle} package_descriptor)
  ans(package_descriptor)

  map_tryget("${package_descriptor}" dependencies)
  ans(constraints)

  map_keys(${dependencies})
  ans(admissable_uris)

  ## todo:  this has to become nicer.....
  ## actually the whole following section is pretty stupid.
  ## it should just call package_dependency_constraint_derive_single_dependency on 
  ## every package handle / dependecy problem
  ## and every constraint handler should then be able to 
  ## get its own dependencies, possibley with a helper function
  ## ala get_constraint_and_dependencies()....
  map_new()
  ans(empty)
  map_new()
  ans(package_constraint)
  map_set(${package_constraint} constraint_type "package_constraint")
  ## derive package constraints
  package_dependency_constraint_derive_single_dependency(
    "${dependency_problem}"
    "${dependee_handle}"
    "self"
    "${package_constraint}" 
    "${empty}")
  ans(derived_constraints)

  

  foreach(admissable_uri ${admissable_uris})
    map_tryget("${constraints}" "${admissable_uri}")
    ans(dependency_constraint)

    ## gets all dependency handles for admissable_uri
    map_tryget("${dependencies}" "${admissable_uri}")
    ans(dependency_handle_map)
    
    package_dependency_constraint_derive_single_dependency(
      "${dependency_problem}"
      "${dependee_handle}" 
      "${admissable_uri}"
      "${dependency_constraint}" 
      "${dependency_handle_map}"
    )
    ans_append(derived_constraints)

  endforeach()

  return_ref(derived_constraints)
endfunction()