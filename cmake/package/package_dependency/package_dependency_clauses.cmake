## `(<dependency_graph:{ <package uri>:<package handle>... }> <root handle:<package handle>>) -> { <<clause index>: <clause>>...}`
## 
## creates cnf clauses for all dependencies in dependency graph
## 
##
function(package_dependency_clauses package_graph root_handle)
  sequence_new()
  ans(clauses)

  map_tryget(${root_handle} uri)
  ans(dependee_uri)

  ## add root uri to clauses - because the root uri is always reqireud
  sequence_add(${clauses} "${dependee_uri}")
  
  map_values("${package_graph}")
  ans(package_handles)

  ## loop through all package handles in dependency graph 
  ## and add their dependency clauses to clauses sequence
  foreach(package_handle ${package_handles})      
    package_dependency_clauses_add_all("${clauses}" "${package_handle}")
  endforeach()


  return_ref(clauses)
endfunction()