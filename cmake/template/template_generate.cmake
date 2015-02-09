
  ## `template_generate()->`
  ##
  ## *Description*
  ##  parses the content for cmake expressions in <% %> delimiters
  ##  returns cmake code which can be evaluated
  ##
  ##
  ## never use ascii 16 28 29 31 
  function(template_generate content)
    set(delimiter_start "<%")
    set(delimiter_end "%>")

    string(ASCII 16 delimiter)
     string_semicolon_encode("${content}")
     ans(content)
     string_encode_bracket("${content}")
     ans(content)
    string(REPLACE "${delimiter_start}" "${delimiter}" content "${content}")
    string(REPLACE "${delimiter_end}" "${delimiter}" content "${content}")
    set(code_fragment_regex "${delimiter}([^${delimiter}]*)${delimiter}")
    set(literal_fragment_regex "([^${delimiter}]+)")
    string(REGEX MATCHALL "(${code_fragment_regex})|(${literal_fragment_regex})" fragments "${content}")

    set(result)
    foreach(fragment ${fragments})
      string_decode_bracket("${fragment}")
      ans(fragment)
      string_semicolon_decode("${fragment}")
      ans(fragment)
      if("${fragment}" MATCHES "${code_fragment_regex}")
        set(code "${CMAKE_MATCH_1}")
        set(do_output false)
        if("${code}" MATCHES "^=(.*)")
          set(code "${CMAKE_MATCH_1}")
          set(do_output true)
        endif()
        if(NOT "${code}" MATCHES "[a-zA-Z_0-9]\\(.*\\)")
          set(code "format(${code})")
        endif()
        set(result "${result}\n${code}")

        if(do_output)
          set(result "${result}\nset(output \"\${output}\${__ans}\")")
        endif()
      else()
        cmake_string_escape("${fragment}")
        ans(fragment)
        set(result "${result}\nset(output \"\${output}${fragment}\")")
      endif()

    endforeach()
    set(result "
      
      set(output)${result}
      set_ans(\${output})")
    return_ref(result)  
  endfunction()
