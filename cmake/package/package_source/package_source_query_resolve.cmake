## `(<admissable_uri> [--cache <map>])-> { <<package uri>:<package handle>>...}` 
##
##
function(package_source_query_resolve package_source admissable_uri)
  set(args ${ARGN})    

  ## get cache and if none exists create new
  list_extract_labelled_value(args --cache)
  ans(cache)
  if(NOT cache)
    map_new()
    ans(cache)
  endif()

  #message("uri ${admissable_uri}")

  set(resolved_handles)
  map_has("${cache}" "${admissable_uri}")
  ans(hit)
  if(hit)
    map_tryget("${cache}" "${admissable_uri}")
    ans(resolved_handles)
    #message("hit for ${admissable_uri} :${resolved_handles}")

  else()
    if(NOT package_source)
      message(FATAL_ERROR "no package source specified!")
    endif()
    call(package_source.query("${admissable_uri}"))
    ans(dependable_uris)

    ## resolve loop
    foreach(dependable_uri ${dependable_uris})
      package_source_resolve("${package_source}" "${dependable_uri}" --cache ${cache})
      ans(resolved_handle)
      if(resolved_handle)
        map_append_unique("${cache}" "${admissable_uri}" ${resolved_handle})
        list(APPEND resolved_handles ${resolved_handle})
      endif()
    endforeach()
  endif()

  map_new()
  ans(result)
  foreach(resolved_handle ${resolved_handles})
    map_tryget(${resolved_handle} uri)
    ans(resolved_uri)
    map_set(${result} ${resolved_uri} ${resolved_handle})
  endforeach()
  return_ref(result)
endfunction()
