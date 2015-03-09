
  function(package_source_pull_metadata uri)
    set(args ${ARGN})
    list_pop_front(args)
    ans(content_dir)
    path_qualify(content_dir)

    package_source_resolve_metadata("${uri}")
    ans(package_handle)

    if(NOT package_handle)
      return()
    endif()

    mkdir("${content_dir}")
    map_set(${package_handle} content_dir "${content_dir}")
    return_ref(package_handle)
  endfunction()
