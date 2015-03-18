
  function(package_source_rate_uri_webarchive uri)
    uri_coerce(uri)

    uri_check_scheme(${uri} "http?" "https?")
    ans(scheme_ok)
    if(NOT scheme_ok)
      return(0)
    endif()



    map_tryget(${uri} file)
    ans(file)

    if("${file}" MATCHES "(tar\\.gz$)|(\\.gz$)")
      return(1000)
    endif()

    return(50)
  endfunction()