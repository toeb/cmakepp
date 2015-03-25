## ``
##
## creates a package dependency problem context
function(package_dependency_problem package_graph root_handle)
  set(args ${ARGN})

  set(constraint_handlers 
    package_dependency_constraint_required
    package_dependency_constraint_optional
    package_dependency_constraint_mutually_exclusive
    package_dependency_constraint_semantic_version
    package_dependency_constraint_incompatible
    package_dependency_constraint_root_package
    )
  map_capture_new(
    package_graph
    root_handle 
    clauses 
    reasons
    cache
    constraint_handlers
    )
  return_ans()

endfunction()