## `(<package dependency problem>)-><bool>`
##
## initializes the dependency problem after it was configured
## derives the constraints and clauses and adds them to the dependency problem
## returns true on success
function(package_dependency_problem_init dependency_problem)
  is_address("${dependency_problem}")
  ans(is_ok)
  if(NOT is_ok)
    message(FATAL_ERROR "expected a dependency problem object")
  endif()

  ## create boolean satisfiablitiy problem 
  ## by getting all clauses
  package_dependency_constraint_derive_all(${dependency_problem})
  ans(clauses)
  map_set(${dependency_problem} clauses "${clauses}")  

  ## reformulate clause objects to cnf clauses
  sequence_new()
  ans(cnf_clauses)
  foreach(clause ${clauses})
    map_tryget(${clause} literals)
    ans(literals)
    sequence_add(${cnf_clauses} ${literals})
    ## debug output
    string(REPLACE ";" "|" literals "${literals}")
    log("{clause.reason}.  derived clause: ({literals})" --trace --function package_dependency_problem_init)
  endforeach()

  ## create cnf
  cnf("${cnf_clauses}")
  ans(cnf)

  map_set(${dependency_problem} cnf "${cnf}")

  return(true)

endfunction()