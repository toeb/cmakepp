## `(<package handle> [--cache <map>])->`
##
##
## resolves all dependencies for the specified package_handle
## keys of `package_handle.package_descriptor.dependencies` are `admissable uri`s 
## `admissable uri`s are resolved to `dependency handle`s 
## returns a map of `<admissable_uri>: <dependency handle>` if no dependencies are present 
## an empty map is returned
## sideffects 
## sets `<package handle>.dependencies.<admissable uri> = { <<dependable uri>:<dependency handle>>... }` 
## adds  to `<dependency handle>.dependees.<package uri> = { <admissable_uri>:<package handle> }` 
function(package_dependency_resolve package_source  package_handle )
  set(args ${ARGN})
  list_extract_labelled_value(args --cache)
  ans(cache)
  if(NOT cache)
    map_new()
    ans(cache)
  endif()

  if(NOT package_handle)
    message(FATAL_ERROR "no package handle specified")
  endif()

  map_get_map(${package_handle} dependency_descriptor)
  ans(dependency_descriptor)


  ## get the dependencies specified in package_handle's package_descriptor
  ## it does not matter if the package_descriptor does not exist
  set(admissable_uris)
  map_tryget("${package_handle}" package_descriptor)
  ans(package_descriptor)
  if(package_descriptor)
    map_tryget("${package_descriptor}" dependencies)
    ans(dependencies)
    if(dependencies)
      map_keys("${dependencies}")
      ans(admissable_uris)
    endif()
  endif()

  ## get package uri
  map_tryget(${package_handle} uri)
  ans(package_uri)

  #message(FORMAT "package_dependency_resolve: trying to resolve ${admissable_uris}")

  ## resolve all package dependencies
  ## and assign package handles dependencies property
  package_source_query_resolve_all("${package_source}" ${admissable_uris} --cache ${cache})
  ans(dependencies)

  ## todo replace first with latter
  map_set(${package_handle} dependencies ${dependencies})

  ## loop through all admissable uris 
  ## and assign dependees property 
  
  foreach(admissable_uri ${admissable_uris})
    ## get map for admissable_uri
    map_tryget(${dependencies} "${admissable_uri}")
    ans(dependency)

    map_keys(${dependency})
    ans(dependable_uris)
    foreach(dependency_uri ${dependable_uris})      
      map_tryget(${dependency} ${dependency_uri})
      ans(dependency_handle)
      
      map_tryget(${dependency_handle} dependees)
      ans(dependees)
      if(NOT dependees)
        map_new()
        ans(dependees)
        map_set(${dependency_handle} dependees ${dependees}) 
      endif()
      map_tryget(${dependees} ${package_uri})
      ans(dependee)
      if(NOT dependee)
        map_new()
        ans(dependee)
        map_set(${dependees} ${package_uri} ${dependee})
      endif()
      map_append_unique("${dependee}" "${admissable_uri}" "${package_handle}")
    endforeach()
  endforeach()

  return_ref(dependencies)
endfunction()
