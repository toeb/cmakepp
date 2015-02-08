macro(check_host url)
 
  # expect webservice to be reachable
  http_get("${url}" --return-code)
  ans(error)

  if(error)
    message("Test inconclusive webserver unavailable")
    return()
  endif()

endmacro()