## (<installed package> <~uri> [--reference] [--consume] <package_content_copy_args:<args...>?>)
##
parameter_definition(package_source_push_path
  )
function(package_source_push_path)
    arguments_extract_defined_values(0 ${ARGC} package_source_push_path)
    ans(args)    
    if("${args}" MATCHES "(.*);=>;?(.*)")
        set(source_args "${CMAKE_MATCH_1}")
        set(args "${CMAKE_MATCH_2}")
    else()
        set(source_args ${args})
        set(args)
    endif()

    list_pop_front(source_args)
    ans(source)
        
    ## get target dir
    list_pop_front(args)
    ans(target_dir)
    if(NOT target_dir)
        pwd()
        ans(target_dir)        
    endif()

    
    path_qualify(target_dir)

    log("pushing {source.name}({source_args}) to '${target_dir}'...")    

    assign(package_handle = source.pull(${source_args} "${target_dir}"))

    if(NOT package_handle)
        error("could not pull `${source_args}` ")
        return()
    endif()

    log("pushed {package_handle.package_descriptor.id}@{package_handle.package_descriptor.version} to '${target_dir}'")
    
    if(NOT EXISTS "${target_dir}/package.cmake")
        log("no package descriptor existed.  writing package.cmake")
        assign(package_descriptor = package_handle.package_descriptor)
        json_write("${target_dir}/package.cmake" "${package_descriptor}")
    endif()

    return_ref(package_handle)
endfunction()