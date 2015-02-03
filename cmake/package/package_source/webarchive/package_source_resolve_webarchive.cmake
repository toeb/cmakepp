

  function(package_source_resolve_webarchive uri)
    set(args ${ARGN})
    package_source_query_webarchive("${uri}" ${args})
    ans(valid_uri_string)
    list(LENGTH valid_uri_string uri_count)
    if(NOT uri_count EQUAL 1)
      return()
    endif()

    download_cached("${valid_uri_string}" --readonly)
    ans(cached_archive_path)

    package_source_resolve_archive("${cached_archive_path}")
    ans(result)


    map_set(${result} uri "${valid_uri_string}")
    map_remove(${result} content_dir)

    return(${result})
  endfunction()



