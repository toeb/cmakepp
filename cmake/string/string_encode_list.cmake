# encodes a string list so that it can be correctly stored and retrieved
function(string_encode_list str)
  string_semicolon_encode("${str}")
  ans(str)
  string_encode_bracket("${str}")
  ans(str)
  string_encode_empty("${str}")
  return_ans()
endfunction()