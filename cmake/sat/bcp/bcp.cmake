## `(<f:<cnf>> <clauses:{<<index>:<literal index...>...>}> <assignments:{<<literal index>:<bool>...>} <decisions:<literal index>...>)`
## 
## propagates the unit clauses in the cnf consisting of clauses
## 
## propagates assignment values for the specified `<decisions>`
## sets literal assignments in <assignments>
## returns the indices of the deduced literals
## returns "conflict" if an assignment conflicts with an existing one in <assignments>
## returns "unsatisfied" if cnf is unsatisfiable 
## 
function(bcp f clauses assignments)
  map_import_properties(${f} literal_inverse_map) ## simplification inverse = i+-1

  bcp_deduce_assignments("${f}" "${clauses}" "${assignments}")
  ans(deduced_assignments)

  if("${deduced_assignments}" MATCHES "(conflict)|(unsatisfied)")
    return_ref(deduced_assignments)
  endif()
  
  set(all_deductions)
  set(propagation_queue ${deduced_assignments} ${ARGN})

  while(NOT "${propagation_queue}_" STREQUAL "_")
    list_pop_front(propagation_queue)
    ans(li)

    map_tryget(${assignments} ${li})
    ans(vi)

    bcp_simplify_clauses("${f}" "${clauses}" "${li}" "${vi}")
    
    bcp_deduce_assignments("${f}" "${clauses}" "${assignments}")
    ans(deduced_assignments)

    if("${deduced_assignments}" MATCHES "(conflict)|(unsatisfied)")
      return_ref(deduced_assignments)
    endif()
    list(APPEND propagation_queue ${deduced_assignments})
    list(APPEND all_deductions ${deduced_assignments})
    list_remove_duplicates(propagation_queue)
  endwhile()
  return_ref(all_deductions)
endfunction()
