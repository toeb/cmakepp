
  function(argument_escape arg)
    cmake_string_escape("${arg}")
    ans(arg)
    return_ref(arg)
    if("${arg}_" MATCHES "(^_$)|(;)|(\")")
      set(arg "\"${arg}\"") 
    endif()
    return_ref(arg)
  endfunction()