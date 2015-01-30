macro(check_host url)
 


# ensure that the package exists

  # expect webservice to be reachable
  http_get("${url}" "")
  ans(response)
  
  map_navigate(ok "response.code")
  if(NOT "${ok}" STREQUAL 200)
    message("Test inconclusive webserver unavailable")
    return()
  endif()

endmacro()