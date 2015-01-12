

  ## tries to parse structured data
  ## if structured data is not parsable returns the value passed
  function(data)
    set(result)
    foreach(arg ${ARGN})

      if("${arg}" MATCHES "^(\\[|{).*(\\]|})$")
        script("${arg}")
        ans(val)
      else()
        set(val "${arg}")        
      endif()
      list(APPEND result "${val}")
    endforeach()  
    return_ref(result)
  endfunction()