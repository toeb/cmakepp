
  function(string_decode_bracket str)
    #message("decoded1 :${str}")
    string(REPLACE "«" "["  str "${str}")
    string(REPLACE "»" "]"  str "${str}")
    #message("decoded2 :${str}")
    return_ref(str)
  endfunction()