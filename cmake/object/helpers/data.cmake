

  ## tries to parse structured data
  ## if structured data is not parsable returns the value passed
  function(data)
    set(result)
    set(args ${ARGN})
    foreach(arg ${args})
      if("_${arg}" MATCHES "^_(\\[|{).*(\\]|})$")
        script("${arg}")
        ans(val)
      else()
        set(val "${arg}")        
      endif()
      list(APPEND result "${val}")
    endforeach()  
    return_ref(result)
  endfunction()