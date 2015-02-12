
  ## package_source_pull_managed(<~uri>) -> <package handle>
  ## --reference returns the package with the content still pointing to the original content dir
  function(package_source_pull_managed uri)
    set(args ${ARGN})

    uri_coerce(uri)

    package_source_resolve_managed("${uri}")
    ans(package_handle)
    if(NOT package_handle)
      return()
    endif()

    list_extract_flag(args --reference)
    ans(reference)


    ## if in reference mode copy package_handle content and set new content_dir
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


