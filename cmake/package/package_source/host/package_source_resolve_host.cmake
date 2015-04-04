## `(<uri>)-><package handle>`
## 
## tries to find the package identified by the uri 
function(package_source_resolve_host uri)
  uri_coerce(uri)
  package_source_query_host("${uri}" --package-handle)
  ans(package_handle)


  list(LENGTH package_handle count)

  if(NOT "${count}" EQUAL 1)
    error("could not unqiuely resolve {uri.uri} to a single package uri (got {count})")
    return()
  endif()

  map_tryget(${package_handle} environment_descriptor)
  ans(environment_descriptor)

  map_new()
  ans(package_descriptor)

  map_set(${package_descriptor} environment_descriptor ${environment_descriptor})
  map_set(${package_handle} package_descriptor ${package_descriptor})


  return_ref(package_handle)
endfunction()