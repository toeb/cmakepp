
  function(package_source_pull_archive uri)
    set(args ${ARGN})

    ## get package from uri

    package_source_resolve_archive("${uri}")
    ans(package)

    if(NOT package)
      return()
    endif()

    ## get valid uri from package
    map_tryget(${package} uri)
    ans(uri)

    uri_to_localpath("${uri}")
    ans(archive_path)

    list_pop_front(args)
    ans(target_dir)


    ## uncompress compressed file to target_dir
    pushd("${target_dir}" --create)
      ans(target_dir)
      uncompress("${archive_path}")
    popd()

    ## set content_dir
    map_set(${package} content_dir "${target_dir}")


    return_ref(package)
  endfunction()
