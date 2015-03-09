## `(<admissable uri>... [--cache <map>])-> { <<admissable uri>:<package handle>>... }`
##
##
function(package_source_query_resolve_all package_source)
  set(args ${ARGN})
  list_extract_labelled_value(args --cache)
  ans(cache)
  if(NOT cache)
    map_new()
    ans(cache)
  endif()
  set(admissable_uris ${args})
  
  map_new()
  ans(result)


  ## loop througgh all admissable uris
  foreach(admissable_uri ${admissable_uris})
    package_source_query_resolve("${package_source}" "${admissable_uri}" --cache ${cache})
    ans(resolved)
    map_set(${result} ${admissable_uri} ${resolved})
  endforeach()

  return_ref(result)
endfunction()


