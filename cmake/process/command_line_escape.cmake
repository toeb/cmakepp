
  ## escapes a command line quoting arguments as needed 
  function(command_line_escape) 
    set(whitespace_regex "( )")
    set(result)

    foreach(arg ${ARGN})
      string(REGEX MATCH "[\r\n]" m "${arg}")
      if(NOT "_${m}" STREQUAL "_")
        message(FATAL_ERROR "command line argument is invalid - contains CR NL - consider escaping")
      endif()

      string(REGEX MATCH "${whitespace_regex}|\"\"" m "${arg}")
      if(NOT "${m}_" STREQUAL "_")
        string(REPLACE "\"" "\\\"" arg "${arg}")
        set(arg "\"${arg}\"")
      endif()


      list(APPEND result "${arg}")

    endforeach()    
    return_ref(result)
  endfunction()
