
  function(package_source_push_archive)
    if("${ARGN}" MATCHES "(.*);=>;?(.*)")
        set(source_args "${CMAKE_MATCH_1}")
        set(args "${CMAKE_MATCH_2}")
    else()
        set(source_args ${ARGN})
        set(args)
    endif()
    list_pop_front(source_args)
    ans(source)

    list_extract_flag(args --force)
    ans(force)

    list_pop_front(args)
    ans(target_file)

    ## used to pass format along
    list_extract_labelled_keyvalue(args --format)
    ans(format)


    path_qualify(target_file)

    path_temp()
    ans(temp_dir)

    assign(package_handle = source.pull(${source_args} "${temp_dir}"))
    assign(content_dir = package_handle.content_dir)# get content dir because pull may return somtehing different in case --reference is specified
    
    ## possibly generate a filename if ${target_file} is a directory
    if(IS_DIRECTORY "${target_file}")
        set(mimetype ${format})
        list_extract_labelled_value(mimetype --format)
        ans(mimetype)
        if(NOT mimetype)
            set(mimetype "application/x-gzip")
        endif()
        mime_type_get_extension("${mimetype}")
        ans(extension)
        format("{package_handle.package_descriptor.id}-{package_handle.package_descriptor.version}.{extension}")
        ans(filename)
        set(target_file "${target_file}/${filename}")
    endif()
    if(EXISTS "${target_file}")
        if(NOT force)
            error("cannot push: ${target_file} already exists")
            return()
        endif()
        if(IS_DIRECTORY "${target_file}")
            error("cannot push forced: ${target_file} is a directory")
            return()
        endif()
        rm("${target_file}")
    endif()

    ## compress all files in temp_dir into package
    pushd("${content_dir}")
      compress("${target_file}" "**" ${format})
    popd()

    ## cleanup
    rm("${temp_dir}")

    package_source_query_archive("${target_file}")
    ans(package_uri)


    ## set altered uri (now contains hash)
    map_set(${package_handle} uri "${package_uri}")

    return_ref(package_handle)
  endfunction()