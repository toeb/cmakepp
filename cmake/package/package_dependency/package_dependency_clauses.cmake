## `(<package_graph: <package graph>>  <requirements:{<<package uri>:<bool>>...}> )-> { <<clause index>: <clause>>...}`
## 
## 
##
function(package_dependency_clauses package_graph root_handle)
  sequence_new()
  ans(clauses)

  map_tryget(${root_handle} uri)
  ans(root_uri)
  sequence_add(${clauses} "${root_uri}")
  
  map_keys("${package_graph}")
  ans(package_uris)
  
  foreach(package_uri ${package_uris})      
    package_dependency_clauses_add("${clauses}" "${package_graph}" "${package_uri}")
  endforeach()

 #print_vars(clauses)
  return_ref(clauses)
endfunction()