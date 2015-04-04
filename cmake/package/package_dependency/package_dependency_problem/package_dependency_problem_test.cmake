##
##
## helper function to test the package dependency problem. users should not use this
function(package_dependency_problem_test project_dependencies constraint_handlers)
  mock_package_source("mock" ${ARGN})
  ans(package_source)

  map_new()
  ans(cache)

  project_open(".")
  ans(project)

  assign(project.project_descriptor.package_source = package_source)


  assign("!project.package_descriptor.dependencies" = "${project_dependencies}")

  package_dependency_graph_resolve("${package_source}" "${project}" --cache ${cache})
  ans(package_graph)

  package_dependency_problem_new("${package_graph}" "${project}")
  ans(problem)


  assign(problem.constraint_handlers = constraint_handlers)
  
  timer_start(package_dependency_problem_init)
  package_dependency_problem_init("${problem}")
  ans(success)
  timer_print_elapsed(package_dependency_problem_init)

  timer_start(package_dependency_problem_solve)
  package_dependency_problem_solve("${problem}")
  ans(success)
  timer_print_elapsed(package_dependency_problem_solve)

  assign(res = problem.dp_result.initial_context.f.clause_map)

  sequence_to_list("${res}" "|" ")&(")
  ans(res)
  
  set(res "(${res})")
  message("cnf: ${res}")
  return_ref(res)


endfunction()

