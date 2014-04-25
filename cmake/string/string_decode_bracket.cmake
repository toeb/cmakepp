# decodes encoded brakcets in a string
function(string_decode_bracket str)
  string(REPLACE "«" "["  str "${str}")
  string(REPLACE "»" "]"  str "${str}")
  return_ref(str)
endfunction()