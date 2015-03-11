function(package_source_resolve_cached uri)
  set(args ${ARGN})
  list_extract_labelled_keyvalue(args --refresh)
  ans(refresh)
  list_extract_flag(args --cache-container)
  ans(return_cache_container)
  
  uri_coerce(uri)

  package_source_query_cached("${uri}" ${refresh} --cache-container)
  ans(cache_container)


  if("${cache_container}" MATCHES ";")  
    error("multiple matches found")
    return()
  endif()

  set(is_resolved false)

  if(cache_container)
    map_tryget(${cache_container} is_resolved)
    ans(is_resolved)
    assign(uri = cache_container.package_handle.uri)
    ans(uri)
    uri_coerce(uri)
  else()
    map_new()
    ans(cache_container)
  endif()

  if(NOT is_resolved)

    assign(package_handle = this.inner.resolve("${uri}"))
    if(NOT package_handle)
      error("cache package source: inner package source could not resolve {uri.uri}")
      return()
    endif()
    map_set(${cache_container} is_resolved true)
    map_set(${cache_container} package_handle ${package_handle})
    assign(success = this.indexed_store.save("${cache_container}"))
  else()
    #message(FORMAT "RESOLVE_HIT {uri.uri}")
  endif()

  if(return_cache_container)
    return_ref(cache_container)
  endif()


  map_tryget(${cache_container} package_handle)
  ans(package_handle)

  return_ref(package_handle)
endfunction()