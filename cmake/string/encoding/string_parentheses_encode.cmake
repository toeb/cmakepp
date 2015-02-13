
# encodes parentheses in a string
  function(string_parentheses_encode str)
    string_codes()
    string(REPLACE "\(" "${paren_open_code}" str "${str}")
    string(REPLACE "\)" "${paren_close_code}" str "${str}")
    return_ref(str)
  endfunction()


