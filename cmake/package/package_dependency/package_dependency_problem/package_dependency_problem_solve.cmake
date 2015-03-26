

function(package_dependency_problem_solve dependency_problem)


  map_tryget(${dependency_problem} cnf)
  ans(cnf)

  ## solve boolean satisfiablitiy problem
  dp_naive("${cnf}")
  ans(result)

  map_set(${dependency_problem} dp_result "${result}")

  return(true)
endfunction()