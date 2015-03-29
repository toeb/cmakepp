## `(<package graph> <root_handle:<package handle>>)-><package dependency problem>`
##
## ```
## <package dependency problem> ::= {
##  package_graph: {<<package uri>:<package handle>>...}
##  constraint_handlers: <callable:<(...)-><package dependency constraint>>>...
##  root_handle: <package handle>   
##  cnf :  <cnf>          # the conjuntive normal form SAT problem formulation
##  dp_result: {...}      # result of the SAT solver
##  clauses: <package dependency constraint clause 
## }
## ```
## creates a package dependency problem context
function(package_dependency_problem_new package_graph root_handle)
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
    constraint_handlers
    )
  return_ans()

endfunction()