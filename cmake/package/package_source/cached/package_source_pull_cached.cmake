function(package_source_pull_cached uri)
  set(args ${ARGN})
  list_extract_labelled_keyvalue(args --refresh)
  ans(refresh)

  uri_coerce(uri)

  list_pop_front(args)
  ans(target_dir)
  path_qualify(target_dir)


  package_source_resolve_cached("${uri}" ${refresh} --cache-container)
  ans(cache_container)

  if(NOT cache_container)
    return()
  else()
    assign(uri = cache_container.package_handle.uri)
    uri_coerce(uri)
  endif()


  this_get(cache_dir)
  map_tryget(${cache_container} cache_key)
  ans(cache_key)

  set(content_dir "${cache_dir}/content/${cache_key}")
  if(NOT EXISTS "${content_dir}")
    #message(FORMAT "PULL_MISS {uri.uri}")
    ## pull
    assign(package_handle = this.inner.pull("${uri}" "${content_dir}"))
    if(NOT package_handle)
      error("failed to pull {uri.uri} after cache miss")
      return()
    endif()
  else()
    #message(FORMAT "PULL_HIT {uri.uri}")
    assign(package_handle = cache_container.package_handle)
  endif()
  
  cp_dir("${content_dir}" "${target_dir}")
  assign(package_handle.content_dir = target_dir )

  return_ref(package_handle)
endfunction()