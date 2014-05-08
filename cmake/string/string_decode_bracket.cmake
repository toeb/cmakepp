# decodes encoded brakcets in a string
function(string_decode_bracket str)
    string(ASCII 29 bracket_open)
    string(ASCII 28 bracket_close)
      string(REPLACE "${bracket_open}" "["  str "${str}") 
      string(REPLACE "${bracket_close}" "]"  str "${str}")
      return_ref(str)

endfunction()
