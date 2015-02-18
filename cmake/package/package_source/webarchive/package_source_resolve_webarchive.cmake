## package_source_resolve_webarchive([--refresh])-><package handle>

  function(package_source_resolve_webarchive uri)
    set(args ${ARGN})
    
    uri("${uri}")
    ans(uri)

    package_source_query_webarchive("${uri}" ${args} --package-handle)
    ans(package_handle)

    list(LENGTH package_handle count)
    if(NOT count EQUAL 1)
      error("could not resolve {uri.uri} matches {count} packages - needs to be unqiue" --aftereffect)
      return()
    endif()

    assign(resource_uri = package_handle.resource_uri)

    download_cached("${resource_uri}" --readonly)
    ans(cached_archive_path)

   
    if(NOT cached_archive_path)
        error("could not download {resource_uri}" --aftereffect)
        return()
    endif()
    package_source_resolve_archive("${cached_archive_path}")
    ans(archive_package_handle)
    if(NOT archive_package_handle)
        error("{uri.uri} is not a supported archive file ")
        return()
    endif()


    map_remove(${package_handle} content_dir)
    assign(package_handle.package_descriptor = archive_package_handle.package_descriptor)
    assign(package_handle.archive_descriptor = archive_package_handle.archive_descriptor)

    return_ref(package_handle)

  endfunction()



