macro(check_host url)
 


# ensure that the package exists

  # expect webservice to be reachable
  HttpGet(response "${url}")
  map_navigate(ok "response.code")
  if(NOT "${ok}" STREQUAL 200)
    message("Test inconclusive webserver unavailable")
    return()
  endif()

endmacro()