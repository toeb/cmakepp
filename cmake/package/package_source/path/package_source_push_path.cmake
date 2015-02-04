## package_source_push_path(<installed package> <~uri> <package_content_copy_args:<args...>?>)
  function(package_source_push_path package_handle uri)
    set(args ${ARGN})
    
    ## resolve installed package
    package_handle("${package_handle}")
    ans(package_handle)

    if(NOT package_handle)
      return()
    endif()

    ## get package_descriptor and source_dir from package_handle
    map_tryget(${package_handle} package_descriptor)
    ans(package_descriptor)

    map_tryget(${package_handle} content_dir)
    ans(source_dir)

    ## get target_dir
    uri("${uri}")
    ans(uri)

    uri_to_localpath("${uri}")
    ans(target_dir)

    path_qualify(target_dir)
    

    ## copy content to target dir
    map_tryget("${package_descriptor}" content)
    ans(content_globbing_expression)
    cp_content("${source_dir}" "${target_dir}" ${content_globbing_expression})
    ans(result)


    ## return the valid target uri
    uri("${target_dir}")
    ans(target_uri)

    uri_format(${target_uri})
    ans(target_uri)

    return_ref(target_uri)
  endfunction()