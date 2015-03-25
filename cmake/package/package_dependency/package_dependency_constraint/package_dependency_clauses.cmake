## `(<dependency_graph:{ <package uri>:<package handle>... }> <root handle:<package handle>>) -> { <<clause index>: <clause>>...}`
## 
## creates cnf clauses for all dependencies in dependency graph
## 
##
function(package_dependency_clauses dependency_problem) 
  map_tryget(${dependency_problem} package_graph)
  ans(package_graph)


  map_values("${package_graph}")
  ans(package_handles)

  set(derived_constraints)
  ## loop through all package handles in dependency graph 
  ## and add their dependency clauses to clauses sequence
  foreach(package_handle ${package_handles})      
    package_dependency_constraint_derive_all("${dependency_problem}" "${package_handle}")
    ans_append(derived_constraints)
  endforeach()

  set(clauses)
  foreach(constraint ${derived_constraints})
    map_tryget(${constraint} clauses)
    ans_append(clauses)
  endforeach()

  

  return_ref(clauses)
endfunction()
