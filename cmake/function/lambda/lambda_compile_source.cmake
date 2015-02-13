
  function(lambda2_compile_source source)
    string(ASCII 5 string_token)
    string_encode_list("${source}")
    ans(source)
    # first extract all delimited strings
    regex_delimited_string(' ')
    ans(regex_delimited_string)
    string(REGEX MATCHALL "${regex_delimited_string}" strings "${source}")
    string(REGEX REPLACE "${regex_delimited_string}" "${string_token}" source "${source}")


    string_decode_list("${source}")
    ans(source)

    set(code)
    foreach(line ${source})
      string(REPLACE "," ";" line "${line}")
      set(code "${code}${line}\n")


    endforeach()


    while(true)
      list_pop_front(strings)
      ans(current_string)
      if(NOT current_string)
        break()
      endif()

      string_decode_delimited("${current_string}" ' ')
      ans(current_string)

      string_decode_list("${current_string}")
      ans(current_string)

      cmake_string_escape("${current_string}")
      ans(current_string)



      string_replace_first("${string_token}" "\"${current_string}\"" "${code}")
      ans(code)

    endwhile()
    regex_cmake()
    
    string(REPLACE  "{{}}" "${string_token}" code "${code}" )
    string(REGEX REPLACE "${string_token}" "${string_token}{__ans}" code "${code}")

    string(REGEX REPLACE "{{(${regex_cmake_identifier})}}" "${string_token}{\\1}" code "${code}")
    string(REPLACE "${string_token}" "\$" code "${code}" )

    set(code "${code}return_ans()")
    return_ref(code)

  endfunction()