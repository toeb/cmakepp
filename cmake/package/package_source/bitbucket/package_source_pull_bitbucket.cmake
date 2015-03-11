
  function(package_source_pull_bitbucket uri)
    set(args ${ARGN})

    uri_coerce(uri)

    list_extract_flag(args --use-ssh)
    ans(use_ssh)

    package_source_resolve_bitbucket("${uri}")
    ans(package_handle)

    if(NOT package_handle)
      return()
    endif()

    list_pop_front(args)
    ans(target_dir)

    map_tryget(${package_handle} package_descriptor)
    ans(package_descriptor)

    assign(repo_descriptor = package_handle.bitbucket_descriptor.repository)

    map_tryget(${repo_descriptor} scm)
    ans(scm)

    assign(clone_locations = repo_descriptor.links.clone)
    map_new()
    ans(clone)
    foreach(clone_location ${clone_locations})
      map_import_properties(${clone_location} name href)
      map_set(${clone} ${name} ${href})
    endforeach()

    if(use_ssh)
      set(clone_method ssh)
    else()
      set(clone_method https)
    endif()

    map_tryget(${clone} "${clone_method}")
    ans(clone_uri)


    ## depending on scm pull git or hg
    if(scm STREQUAL "git")
      package_source_pull_git("${clone_uri}" "${target_dir}")
      ans(scm_package_handle)
    elseif(scm STREQUAL "hg")
      package_source_pull_hg("${clone_uri}" "${target_dir}")
      ans(scm_package_handle)
    else()
      message(FATAL_ERROR "scm not supported: ${scm}")
    endif()

    assign(package_handle.repo_descriptor = scm_package_handle.repo_descriptor)

    map_tryget("${scm_package_handle}" package_descriptor)
    ans(scm_package_descriptor)

    map_tryget("${scm_package_handle}" content_dir)
    ans(scm_content_dir)
    
    if(NOT scm_package_descriptor)
      map_new()
      ans(scm_package_descriptor)
    endif()  
    map_defaults("${package_descriptor}" "${scm_package_descriptor}")

    map_set("${package_handle}" content_dir "${scm_content_dir}")

    return_ref(package_handle)
  endfunction()