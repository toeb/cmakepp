## `(<dependency problem>) -> <package dependency constraint clause>...`
## 
## **note** this function will be refactored along with `package_dependency_constraint_derive_single_package` and `package_dependency_constraint_derive`
## creates cnf clauses for all dependencies in the dependency graph
## this is done by walking all package handles of the `dependency_problem.package_graph`
## and calling all `package_dependency_constraint_derive_single_package` on each of the
function(package_dependency_constraint_derive_all dependency_problem) 
  map_tryget(${dependency_problem} package_graph)
  ans(package_graph)


  map_values("${package_graph}")
  ans(package_handles)

set(derived_constraints)
  ## loop through all package handles in dependency graph 
  ## and add their dependency clauses to clauses sequence
  foreach(package_handle ${package_handles})      
    package_dependency_constraint_derive_single_package("${dependency_problem}" "${package_handle}")
    ans_append(derived_constraints)
  endforeach()

  ## loop through all constraints and collect the clauses
  set(clauses)
  foreach(constraint ${derived_constraints})
    map_tryget(${constraint} clauses)
    ans_append(clauses)
  endforeach()


  return_ref(clauses)
endfunction()
