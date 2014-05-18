# decodes semicolons in a string
  function(string_semicolon_decode str)
    string(ASCII  31 us)
    string(REPLACE "${us}" ";" str "${str}")
    return_ref(str)
  endfunction()
