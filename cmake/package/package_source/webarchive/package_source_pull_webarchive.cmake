
  function(package_source_pull_webarchive uri)
    set(args ${ARGN})

    list_extract_flag_name(args --refresh)
    ans(refresh)

    list_pop_front(args)
    ans(target_dir)

    path_qualify(target_dir)

    package_source_resolve_webarchive("${uri}")
    ans(package_handle)

    assign(archive_path = package_handle.archive_descriptor.path)

    package_source_pull_archive("${archive_path}" ${target_dir})

    map_set(${package_handle} content_dir ${target_dir})
    

    return_ref(package_handle)

    package_source_query_webarchive("${uri}" ${refresh})
    ans(package_uri)
    list(LENGTH package_uri uri_count)
    if(NOT uri_count EQUAL 1)
      return()
    endif()

    download_cached("${package_uri}" "${target_dir}" --readonly)
    ans(archive_path)

    package_source_pull_archive("${archive_path}" "${target_dir}")
    ans(package)

    map_set(${package} uri "${package_uri}")
    map_set(${package} content_dir "${target_dir}")

    return_ref(package)
  endfunction()

