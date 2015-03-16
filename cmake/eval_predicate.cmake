
  function(eval_predicate)
    arguments_encoded_list2(0 ${ARGC})
    ans(arguments)

    regex_cmake()


    string(REGEX REPLACE "{([^}]*)}" "\\1" arguments "${arguments}")

    cmake_arguments_quote_if_necessary(${arguments})
    ans(arguments)

    string_combine(" " ${arguments})
    ans(predicate)
    #_message("${predicate}")
    set(code "
      if(${predicate})
        set_ans(true)
      else()
        set_ans(false)
      endif()
    ")

  #  _message("${code}")
    eval("${code}")
    return_ans()
  endfunction()