

  function(token_range_replace_cmake start end code)
    cmake_parse_string("${code}")
    ans(tokens)
    list_peek_front(tokens)
    ans(replace_start)
    list_peek_back(tokens)
    ans(replace_end)
    token_range_replace("${start}" "${end}" "${replace_start}" "${replace_end}")
  endfunction()