
  function(package_source_query_host uri)
    set(args ${ARGN})

    list_extract_flag(args --package-handle)
    ans(return_package_handle)

    uri_coerce(uri)

    ## uri needs to have the host scheme
    uri_check_scheme("${uri}" host)
    ans(ok)

    map_tryget(${uri} scheme_specific_part)
    ans(hostname)

    if(NOT ok)
      return()
    endif()

    if(hostname AND NOT "${hostname}" STREQUAL "localhost")
      return()
    endif()


    cmake_environment()
    ans(environment)

    set(result "host:localhost")
    if(return_package_handle)
      set(package_handle)
      assign(!package_handle.uri = result)
      assign(!package_handle.query_uri = uri.uri)
      assign(!package_handle.environment_descriptor = environment)
      set(result "${package_handle}")
    endif()

    return_ref(result)
  endfunction()
