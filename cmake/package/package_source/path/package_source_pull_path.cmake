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

    uri_coerce(uri)

    ## get package descriptor for requested uri
    package_source_resolve_path("${uri}")
    ans(package_handle)

    if(NOT package_handle)
        error("could not resolve {uri.uri} to a unique package")
      return()
    endif()


    list_extract_flag(args --reference)
    ans(reference)

    if(NOT reference)
        ## get and qualify target path
        list_pop_front(args)
        ans(target_dir)
        path_qualify(target_dir)


        assign(source_dir = package_handle.directory_descriptor.path)

        ## copy content to target dir
        assign(content_globbing_expression = package_handle.package_descriptor.content)

        cp_content("${source_dir}" "${target_dir}" ${content_globbing_expression})

        ## replace content_dir with the new target path and return  package_handle
        map_set("${package_handle}" content_dir "${target_dir}")
    else()
        assign(package_handle.content_dir = package_handle.directory_descriptor.path)
    endif()

    return_ref(package_handle)
endfunction()