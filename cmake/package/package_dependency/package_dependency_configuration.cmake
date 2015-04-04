## `(<package source> <package handle>  [--cache <map>] )-> <dependency configuration>`
##  
## the `<dependency configuration> ::= { <<dependable uri>:<bool>>... }`
## is a map which indicates which dependencies MUST BE present and which MAY NOT
##
##  returns a map of `package uri`s which consist of a valid dependency configuration
##  { <package uri>:{ state: required|incompatible|optional}, package_handle{ dependencies: {packageuri: package handle} } }
##  or a reason why the configuration is impossible
##
##  **sideffects**
## *sets the `dependencies` property of all `package handle`s to the configured dependency using `package_dependency_configuration_set`.
##  
function(package_dependency_configuration package_source root_handle)  
  package_dependency_resolve_and_satisfy("${package_source}" "${root_handle}" ${ARGN})
  ans(dependency_problem)

  ## get the assignments
  map_tryget(${dependency_problem} dp_result)
  ans(dp_result)
  map_tryget(${dp_result} atom_assignments)
  ans(assignments)

  map_tryget(${dependency_problem} package_graph)
  ans(package_graph)
  map_values("${package_graph}")
  ans(package_handles)

  if(assignments)
    ## update the package handles
    package_dependency_configuration_set("${assignments}" ${package_handles})
  endif()
  return_ref(assignments)
endfunction()



