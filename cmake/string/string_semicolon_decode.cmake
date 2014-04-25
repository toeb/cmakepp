# decodes semicolons in a string
  function(string_semicolon_decode str)
    string(REPLACE "…" ";" str "${str}")
    return_ref(str)
  endfunction()
