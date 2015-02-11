## package_source_pull_hg
##
## 
  function(package_source_pull_hg uri)
    set(args ${ARGN})

    uri("${uri}")
    ans(uri)


    list_pop_front(args)
    ans(target_dir)

    path_qualify(target_dir)
    
    package_source_resolve_hg("${uri}")
    ans(package_handle)



    if(NOT package_handle)
        return()
    endif()



    assign(remote_uri = package_handle.scm_descriptor.ref.uri)
    assign(hash = package_handle.scm_descriptor.ref.hash)

    hg_cached_clone("${remote_uri}" --ref "${hash}" "${target_dir}")
    ans(target_dir)

    map_set(${package_handle} content_dir "${target_dir}")


    return_ref(package_handle)
  endfunction()