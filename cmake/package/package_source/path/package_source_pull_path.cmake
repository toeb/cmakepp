## package_source_pull(<~uri> <?target_dir:<path>>) -> <package handle>
##
## pulls the content of package specified by uri into the target_dir 
## if the package_descriptor contains a content property it will interpreted
## as a glob/ignore expression list when copy files (see cp_content(...)) 
##
## --reference flag indicates that nothing is to be copied but the source 
##             directory will be used as content dir 
##
## 
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
        ans(source_dir)

        ## copy content to target dir
        map_tryget("${package_descriptor}" content)
        ans(content_globbing_expression)
        cp_content("${source_dir}" "${target_dir}" ${content_globbing_expression})

        ## replace content_dir with the new target path and return  package_handle
        map_set("${package_handle}" content_dir "${target_dir}")
    endif()

    return_ref(package_handle)
endfunction()