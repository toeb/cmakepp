## `()-><dependency configuration>`
##
## 
function(project_handle_update_dependencies package_source project_handle)
  set(args ${ARGN})
  ## get cache if available - else create a new one
  list_extract_labelled_value(args --cache)
  ans(cache)
  if(NOT cache)
    ## cache map 
    map_new()
    ans(cache)
  endif()

  package_dependency_update_handle(${project_handle} ${args})
  ans(changes)

 # json_print(${project_handle})

  package_dependency_configuration(
    ${package_source} 
    ${project_handle}
    --cache ${cache}
  )

  ans(configuration)

  return_ref(configuration)
endfunction()



