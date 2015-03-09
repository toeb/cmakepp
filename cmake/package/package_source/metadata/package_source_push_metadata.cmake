
  function(package_source_push_metadata)
    if("${ARGN}" MATCHES "(.*);=>;?(.*)")
        set(source_args "${CMAKE_MATCH_1}")
        set(args "${CMAKE_MATCH_2}")
    else()
        set(source_args ${ARGN})
        set(args)
    endif()
    list_pop_front(source_args)
    ans(source)

    list_pop_front(source_args)
    ans(uri)

    uri_coerce(uri)

    assign(package_handle = source.resolve(${uri}))
    if(NOT package_handle)
      error("could not resolve {uri.uri} to a package handle")
      return()
    endif()

    map_tryget(${package_handle} package_descriptor)
    ans(package_descriptor)

    package_source_metadata_add_descriptor(${package_descriptor})
    return_ref(package_handle)
  endfunction() 
