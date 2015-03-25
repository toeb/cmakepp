## `()-><dependency configuration>`
##
## 
function(package_dependency_configuration_update package_source project_handle)
  set(args ${ARGN})
  ## get cache if available - else create a new one
  list_extract_labelled_value(args --cache)
  ans(cache)
  if(NOT cache)
    map_new()
    ans(cache)
  endif()

  package_handle_update_dependencies(${project_handle} ${args})
  ans(changes)

  package_dependency_configuration("${package_source}" "${project_handle}" --cache ${cache})
  ans(configuration)

  return_ref(configuration)
endfunction()



