## (<installed package> <~uri> [--reference] [--consume] <package_content_copy_args:<args...>?>)
##
function(package_source_push_path)
    if("${ARGN}" MATCHES "(.*);=>;?(.*)")
        set(source_args "${CMAKE_MATCH_1}")
        set(args "${CMAKE_MATCH_2}")
    else()
        set(source_args ${ARGN})
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

    assign(package_handle = source.pull(${source_args} "${target_dir}"))


    if(NOT package_handle)
        error("could not pull `${source_args}` ")
        return()
    endif()

    if(NOT EXISTS "${target_dir}/package.cmake")
        assign(package_descriptor = package_handle.package_descriptor)
        json_write("${target_dir}/package.cmake" "${package_descriptor}")
    endif()

    return_ref(package_handle)
endfunction()