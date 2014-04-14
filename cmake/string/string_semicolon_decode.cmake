
  function(string_semicolon_decode str)
    string(REPLACE "…" ";" str "${str}")
  endfunction()
