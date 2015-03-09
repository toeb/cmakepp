## `(<clauses:<sequence>> <dependee_handle:<package handle>>)-><void>`
##
##
## adds depdency clauses resulting from dependee handle to the 
## clauses sequence.  Currently only supports  
##
## **currently only supports true, false and "" constraints**
function(package_dependency_clauses_add_all clauses dependee_handle)

  map_tryget(${dependee_handle} dependencies)
  ans(dependencies)

  map_tryget(${dependee_handle} package_descriptor)
  ans(package_descriptor)

  map_tryget("${package_descriptor}" dependencies)
  ans(constraints)


  map_keys(${dependencies})
  ans(admissable_uris)

  foreach(admissable_uri ${admissable_uris})
    map_tryget("${constraints}" "${admissable_uri}")
    ans(dependency_constraint)

    ## gets all dependency handles for admissable_uri
    map_tryget("${dependencies}" "${admissable_uri}")
    ans(dependency_handle_map)
    
    package_dependency_clauses_add(
      "${clauses}" 
      "${dependee_handle}" 
      "${dependency_constraint}" 
      "${dependency_handle_map}"
    )
  endforeach()

endfunction()