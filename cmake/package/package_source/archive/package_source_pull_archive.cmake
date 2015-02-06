## package_source_pull_archive(<~uri> <?target_dir>)-><package handle>
##
## pulls the specified archive into the specified target dir
## 
  function(package_source_pull_archive uri)
    set(args ${ARGN})

    list_pop_front(args)
    ans(target_dir)

    path_qualify(target_dir)

    uri("${uri}")
    ans(uri)

    ## get package from uri

    package_source_resolve_archive("${uri}")
    ans(package_handle)

    if(NOT package_handle)
      error("could not resolve specified uri {uri.uri} to a package file")
      return()
    endif()

    assign(archive_path = package_handle.archive_descriptor.path)

    ## uncompress compressed file to target_dir
    pushd("${target_dir}" --create)
      ans(target_dir)
      uncompress("${archive_path}")
    popd()

    ## set content_dir
    map_set(${package_handle} content_dir "${target_dir}")


    return_ref(package_handle)
  endfunction()
