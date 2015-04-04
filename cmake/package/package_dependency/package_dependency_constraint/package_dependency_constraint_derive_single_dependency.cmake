## `(<dependency problem>)-><package dependency constraint>...`
##
## this function tries to derive constraints for the specified package handle
## uses the constraint handlers specified in `dependency_problem.constraint_handlers`
function(package_dependency_constraint_derive_single_dependency
  dependency_problem
  dependee_handle 
  admissable_uri
  dependency_constraint
  possible_dependencies
  )

  ## if dependency_constraint is a map it is a valid depndency constraint
  is_address("${dependency_constraint}")
  ans(is_address)
  if(is_address)

    map_tryget(${dependency_constraint} constraint_type)
    ans(constraint_type)

    if("${constraint_type}_" STREQUAL "_")
        map_set(${dependency_constraint} constraint_type "required")
        set(constraint_type "required")
    endif()

    if("${constraint_type}_" STREQUAL "_")
        error("invalid constraint type for {dependee_handle.uri} => {admissable_uri} (got '{constraint_type}')")
      return()
    endif()

    set(derived_constraints)
    map_tryget(${dependency_problem} constraint_handlers)
    ans(constraint_handlers)
    foreach(handler ${constraint_handlers})
      call2(
        "${handler}" 
        "${dependency_problem}" 
        "${dependee_handle}" 
        "${admissable_uri}" 
        "${dependency_constraint}"
        "${possible_dependencies}"
        )
      ans_append(derived_constraints)
    endforeach()

    return_ref(derived_constraints)
  endif()

  ## if the dependency_constraint is not a map it may either by empty, optional , true or false
  ## the correct object will be created and recursively handled
  if("${dependency_constraint}_" STREQUAL "_" OR "${dependency_constraint}_" STREQUAL "optional_")
    map_new()
    ans(dependency_constraint)
    map_set(${dependency_constraint} constraint_type optional)
  elseif("${dependency_constraint}" MATCHES "^((true)|(false))$")
    map_new()
    ans(dependency_constraint)

    if(CMAKE_MATCH_1)
      map_set(${dependency_constraint} constraint_type required)
    else()
      map_set(${dependency_constraint} constraint_type incompatible)
    endif()
  else()
    error("invalid dependency constraint: '${dependency_constraint}'")
    return()
  endif()

  package_dependency_constraint_derive_single_dependency(
    "${dependency_problem}"
    "${dependee_handle}"
    "${admissable_uri}"
    "${dependency_constraint}"
    "${possible_dependencies}"
    )
  return_ans()
endfunction()