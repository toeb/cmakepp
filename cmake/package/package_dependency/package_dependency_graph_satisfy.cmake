
  ## `(<package_graph:{ <<package uri>:<package handle>>... }> <requirements:{<<package uri>:<bool>>...>}> )-:{<<package uri>:<bool>>...}`
  ## 
  ## not the input package handles need to be part of a package graph
  ## takes a map of `<package uri>:<package handle>` and returns a map 
  ## of `<package uri>:<bool>` indicating which package needs to be installd
  ## any package uri not mentioned in returned map is optional and can be added as a 
  ## requirement (the the graph has to be resatisfied)
  function(package_dependency_graph_satisfy package_graph root_handle)
    ## create boolean satisfiablitiy problem 
    package_dependency_clauses("${package_graph}" ${root_handle})
    ans(clauses)

    cnf("${clauses}")
    ans(cnf)
    dp_naive("${cnf}")
    ans(package_configuration)
    if(package_configuration)
      literal_to_atom_assignments("${cnf}" "${package_configuration}")
      ans(package_configuration)
    endif()

    return_ref(package_configuration)    
  endfunction()
