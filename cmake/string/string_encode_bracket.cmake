# encodes brackets
function(string_encode_bracket str)
    string(REPLACE "[" "«" str "${str}")
    string(REPLACE "]" "»" str "${str}")
    return_ref(str)
  endfunction()