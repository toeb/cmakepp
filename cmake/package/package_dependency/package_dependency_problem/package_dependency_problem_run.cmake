## `(<package graph> <root_handle:<package handle>>)-><package dependency problem>`
##
## runs the the package dependency problem just using the package graph and the root handle as input
## returns the completed package dependency problem
function(package_dependency_problem_run package_graph root_handle)

  package_dependency_problem_new("${package_graph}" "${root_handle}")
  ans(dependency_problem)


  package_dependency_problem_init("${dependency_problem}")  
  ans(success)
  if(NOT success)
    message(FATAL_ERROR "failed to initialize dependency_problem")
  endif()

  package_dependency_problem_solve("${dependency_problem}")
  ans(success)
  if(NOT success)
    message(FATAL_ERROR "failed to solve dependency_problem")
  endif()

  package_dependency_problem_complete("${dependency_problem}")
  ans(success)
  if(NOT success)
    message(FATAL_ERROR "failed to complete dependency_problem")
  endif()

  return_ref(dependency_problem)

endfunction()