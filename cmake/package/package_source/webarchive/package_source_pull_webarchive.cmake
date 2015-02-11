
  function(package_source_pull_webarchive uri)
    set(args ${ARGN})

    uri_coerce(uri)

    list_extract_flag_name(args --refresh)
    ans(refresh)

    list_pop_front(args)
    ans(target_dir)

    path_qualify(target_dir)

    package_source_resolve_webarchive("${uri}")
    ans(package_handle)
    if(NOT package_handle)
        error("could not resolve webarchive {uri.uri}" --aftereffect)
        return()
    endif()
    assign(archive_path = package_handle.archive_descriptor.path)

    package_source_pull_archive("${archive_path}" ${target_dir})
    ans(archive_package_handle)
    if(NOT archive_package_handle)
        error("could not pull downloaded archive" --aftereffect)
        return()
    endif()

    map_set(${package_handle} content_dir ${target_dir})
    

    return_ref(package_handle)

  endfunction()

