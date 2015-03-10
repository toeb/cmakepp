
## adds a complex depndency constraint to the dependency clauses
function(package_dependency_clauses_add_complex_constraint clauses dependee_handle dependency_constraint)
  set(dependency_handles ${ARGN})
  map_tryget(${dependee_handle} uri)
  ans(dependee_uri)

  map_tryget(${dependency_constraint} optional)
  ans(is_optional)

  if(NOT is_optional)
    ## required dependency
    ## (!dependee_uri | dependency_uri1 | dependency_uri2 | ...)
    sequence_add(${clauses} "!${dependee_uri}")
    ans(ci)
    foreach(dependency_handle ${dependency_handles})
      map_tryget(${dependency_handle} uri)
      ans(dependency_uri)
      sequence_append("${clauses}" "${ci}" "${dependency_uri}")
    endforeach()      
  endif()
endfunction()