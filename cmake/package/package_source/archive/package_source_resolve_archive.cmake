## package_source_resolve_archive(<~uri>)-> <package handle>
## 
## resolves the specified uri to a unqiue immutable package handle 
function(package_source_resolve_archive uri)
    uri_coerce(uri)


    ## query for uri and return if no single uri is found
    package_source_query_archive("${uri}" --package-handle)
    ans(package_handle)
    list(LENGTH package_handle uri_count)
    if(NOT uri_count EQUAL 1)
      error("archive package source could not resolve a single immutable package for {uri.uri}")
      return()
    endif()

    ## uncompress package descriptor
    assign(archive_path = package_handle.archive_descriptor.path)

    ## search for the first package.cmake file in the archive 
    archive_match_files("${archive_path}" "([^;]+/)?package\\.cmake"  --single)
    ans(package_descriptor_path)    


    if(package_descriptor_path)
        archive_read_file("${archive_path}" "${package_descriptor_path}")
        ans(package_descriptor_content)
    endif()

    json_deserialize("${package_descriptor_content}")
    ans(package_descriptor)


    ## set package descriptor defaults
    assign(file_name = uri.file_name)
    package_descriptor_parse_filename("${file_name}")
    ans(default_package_descriptor)

    map_defaults("${package_descriptor}" "${default_package_descriptor}")
    ans(package_descriptor)


    ## update package handle
    assign(package_handle.package_descriptor = package_descriptor)
    assign(package_handle.archive_descriptor.package_descriptor_path = package_descriptor_path)

    return_ref(package_handle)
endfunction()
