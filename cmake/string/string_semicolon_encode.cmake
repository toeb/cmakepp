
  function(string_semicolon_encode str)
    string(REPLACE ";" "…" str "${str}" )
    return_ref(str)
  endfunction()