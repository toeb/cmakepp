# decodes encoded brakcets in a string
function(string_decode_bracket str)
    string_codes()
    string(REPLACE "${bracket_open_code}" "["  str "${str}") 
    string(REPLACE "${bracket_close_code}" "]"  str "${str}")
    return_ref(str)
endfunction()
