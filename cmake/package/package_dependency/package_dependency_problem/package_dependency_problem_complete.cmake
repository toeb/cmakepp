

## takes the resolve
function(package_dependency_problem_complete dependency_problem)

  map_tryget(${dependency_problem} dp_result)
  ans(result)


  map_tryget(${result} success)
  ans(success)
  

  if(success)
    map_tryget(${result} assignments)
    ans(assignments)  
    map_tryget(${dependency_problem} cnf)
    ans(cnf)
    literal_to_atom_assignments("${cnf}" "${assignments}")
    ans(atom_assignments)
    map_set(${result} atom_assignments ${atom_assignments})
  endif()

  return(${result})
endfunction()
