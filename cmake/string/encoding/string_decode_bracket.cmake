# decodes encoded brakcets in a string
function(string_decode_bracket str)
    string_codes()
  
      string(REPLACE "${bracket_open}" "["  str "${str}") 
      string(REPLACE "${bracket_close}" "]"  str "${str}")
      return_ref(str)

endfunction()
