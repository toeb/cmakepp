
# function(package_dependency_problem_solve dependency_problem) 
#   set(args ${ARGN})

#   is_address("${dependency_problem}")
#   ans(ok)
#   if(NOT ok)
#     return()
#   endif()

#   map_import_properties(${dependency_problem} cache root_handle package_source)

#   ## get cache if available - else create a new one
#   if(NOT cache)
#     ## cache map 
#     map_new()
#     ans(cache)
#     map_set(${dependency_problem} cache)
#   endif()


#   ## returns a map of package_uri -> package_handle
#   package_dependency_graph_resolve("${package_source}" ${root_handle} --cache ${cache}) 
#   ans(package_graph)

#   map_set(${dependency_problem} package_graph ${package_graph})

#   ## creates a package configuration which can be rused to install / uninstall 
#   ## dependencies
#   package_dependency_graph_satisfy(${dependency_problem})
#   ans_extract(result)

#   map_tryget(${result} success)
#   ans(success)
#   if(success)
#     map_tryget(${result} atom_assignments)
#     ans(configuration)  
#     map_values(${package_graph})
#     ans(package_handles)
#     package_dependency_configuration_set(${configuration} ${package_handles})
#   else()
#     set(configuration)
#   endif()

#   return(${result})

# endfunction()



function(package_dependency_problem_solve dependency_problem)


  map_tryget(${dependency_problem} cnf)
  ans(cnf)

  ## solve boolean satisfiablitiy problem
  dp_naive("${cnf}")
  ans(result)

  map_set(${dependency_problem} dp_result "${result}")

  return(true)
endfunction()