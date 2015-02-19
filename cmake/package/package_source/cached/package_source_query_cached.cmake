function(package_source_query_cached uri)
  set(args ${ARGN})
  list_extract_flag(args --cache-container)
  ans(return_cache_container)
  list_extract_flag(args --package-handle)
  ans(return_package_handle)
  list_extract_flag(args --refresh)
  ans(refresh)
  uri_coerce(uri)

  ## find stored package handles
  set(cache_containers)
  if(NOT refresh)
    assign(query_string = uri.uri)
    assign(id_query = uri.params.id)
    assign(container_keys = this.indexed_store.find_keys(
      "package_handle.query_uri==${query_string}"
      "package_handle.uri==${query_string}"
      "package_handle.package_descriptor.id==${id_query}"
    ))
    foreach(container_key ${container_keys})
      assign(container = this.indexed_store.load("${container_key}"))
      map_set(${container} cache_key ${container_key})
      list(APPEND cache_containers ${container})
    endforeach()
  endif()

  ## if none were found query for them and save them
  if(NOT cache_containers)
    #message(FORMAT "QUERY_MISS {uri.uri}")
    assign(package_handles = this.inner.query("${uri}" --package-handle))
    foreach(package_handle ${package_handles})
      map_new()
      ans(container)
      map_set(${container} package_handle ${package_handle})
      assign(cache_key = this.indexed_store.save("${container}"))
      map_set(${container} cache_key ${cache_key})
      list(APPEND cache_containers ${container})
    endforeach()
  else()
    #message(FORMAT "QUERY_HIT {uri.uri}")

  endif()

  if(return_cache_container)
    return_ref(cache_containers)
  endif()

  list_select_property(cache_containers package_handle)
  ans(package_handles)

  if(return_package_handle)
    return_ref(package_handles)
  endif()

  list_select_property(package_handles uri)
  ans(package_uris)

  return_ref(package_uris)
endfunction()