
## `(<package_graph:{ <<package uri>:<package handle>>... }> <requirements:{<<package uri>:<bool>>...>}> )-:{<<package uri>:<bool>>...}`
## 
## not the input package handles need to be part of a package graph
## takes a map of `<package uri>:<package handle>` and returns a map 
## of `<package uri>:<bool>` indicating which package needs to be installd
## any package uri not mentioned in returned map is optional and can be added as a 
## requirement (the the graph has to be resatisfied)
function(package_dependency_graph_satisfy dependency_problem)
  is_address(${dependency_problem})
  ans(is_ok)
  if(NOT is_ok)
    return()
  endif() 

  package_dependency_problem_init("${dependency_problem}")
  ans(success)
  if(NOT success)
    return()
  endif()


  map_tryget(${dependency_problem} cnf)
  ans(cnf)

  ## solve boolean satisfiablitiy problem
  dp_naive("${cnf}")
  ans(result)
  
  package_dependency_problem_run("${dependency_problem}")
  ans(success)
  if(NOT success)
    return()
  endif()



  ## do calculations to complete the problem
  package_dependency_problem_complete("${dependency_problem}")
  ans(result)

  return(${result})
endfunction()
