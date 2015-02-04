
function(package_source_resolve_archive uri)
    ## query for uri and return if no single uri is found
    package_source_query_archive("${uri}")
    ans(valid_uri)

    list(LENGTH valid_uri uri_count)
    if(NOT uri_count EQUAL 1)
      return()
    endif()


    uri("${valid_uri}")
    ans(uri)

    ## read the package_descriptor file from the archive
    ## if it exists
    uri_to_localpath("${uri}")
    ans(archive_path)

    file_tempdir()
    ans(temp_dir)

    uncompress_file("${temp_dir}" "${archive_path}" "package.cmake")
    package_handle("${temp_dir}")
    ans(package_handle)
    rm("${temp_dir}")

    map_tryget("${package_handle}" package_descriptor)
    ans(package_descriptor)

    ## get default values for package_descriptor by parsing
    ## the file name
    map_tryget(${uri} file_name)
    ans(file_name)

    package_descriptor_parse_filename("${file_name}")
    ans(defaults)

    map_defaults("${package_descriptor}" "${defaults}")
    ans(package_descriptor)

    ## response 
    map_new()
    ans(result)
    map_set(${result} package_descriptor "${package_descriptor}")    
    map_set(${result} uri "${valid_uri}")    

    return_ref(result)
endfunction()
