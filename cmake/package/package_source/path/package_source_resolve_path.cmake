## returns a pacakge descriptor if the uri identifies a unique package
function(package_source_resolve_path uri)
    uri_coerce(uri)


    package_source_query_path("${uri}" --package-handle)
    ans(package_handle)

    list(LENGTH package_handle count)
    if(NOT "${count}" EQUAL 1)
        error("could not find a unique immutbale uri for {uri.uri}")
        return()
    endif()


    return_ref(package_handle)

endfunction()
