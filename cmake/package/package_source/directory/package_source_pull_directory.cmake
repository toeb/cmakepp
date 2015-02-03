  ## package_source_pull_directory(<~uri> [--reference]) -> <package handle>
  ## --reference flag 
  function(package_source_pull_directory uri)
    set(args ${ARGN})

    package_source_resolve_directory("${uri}")
    ans(package_handle)

    if(NOT package_handle)
      return()
    endif()

    list_extract_flag(args --reference)
    ans(reference)

    if(NOT reference)
      list_pop_front(args)
      ans(target_dir)
      path_qualify(target_dir)
    
      map_tryget(${package_handle} content_dir)
      ans(source_dir)

      cp_dir("${source_dir}" "${target_dir}")
      map_set(${package_handle} content_dir "${target_dir}")  
    endif()
    
    return_ref(package_handle)
  endfunction()
