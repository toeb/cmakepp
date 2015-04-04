
function(package_dependency_resolve_and_satisfy package_source root_handle)
  set(args ${ARGN})
  list_extract_labelled_value(args --cache)
  ans(cache)
  ## get cache if available - else create a new one
  if(NOT cache)
    ## cache map 
    map_new()
    ans(cache)
  endif()

  ## resolve graph
  package_dependency_graph_resolve("${package_source}" "${root_handle}" --cache ${cache} )
  ans(package_graph)

  ## run dependency problem
  package_dependency_problem_run("${package_graph}" "${root_handle}")
  ans(dependency_problem)
  
  return_ref(dependency_problem)
endfunction()