  #splits the specified string into lines
  ## normally the string would have to be semicolon encoded
  ## to correctly display lines with semicolons 
  function(string_lines input)      
    string_split("${input}" "\n" ";" )
    #string(REPLACE "\n" ";" input "${input}")
    return_ans(lines)
  endfunction()
