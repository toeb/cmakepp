
  function(string_encode_list str)
    string_semicolon_encode("${str}")
    ans(str)
    string_encode_bracket("${str}")
    return_ans()
  endfunction()