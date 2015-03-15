
  function(cmake_tokens tokens)
    string_codes()

    if("${tokens}" MATCHES "^${ref_token}:")
      return_ref(tokens)
    endif()
    cmake_parse_string("${tokens}" --extended)
    return_ans()
  endfunction()