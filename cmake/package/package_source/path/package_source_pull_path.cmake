## package_source_pull(<~uri> <?target:<path>>)
function(package_source_pull_path uri)
    set(args ${ARGN})


    ## get package descriptor for requested uri
    package_source_resolve_path("${uri}")
    ans(package_handle)

    if(NOT package_handle)
      return()
    endif()


    map_tryget(${package_handle} package_descriptor)
    ans(package_descriptor)

    list_extract_flag(args --reference)
    ans(reference)


    if(NOT reference)
        ## get and qualify target path
        list_pop_front(args)
        ans(target_dir)
        path_qualify(target_dir)

        ## get local_ref which is were the package is stored locally in a path package source
        map_tryget("${package_handle}" "content_dir")
        ans(source_path)

        package_content_copy("${package_descriptor}" "${source_path}" "${target_dir}" ${args})

        ## replace content_dir with the new target path and return  package_handle
        map_set("${package_handle}" content_dir "${target_dir}")
    endif()

    return_ref(package_handle)
endfunction()