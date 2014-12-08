  #splits the specified string into lines 
  function(string_lines input)      
    string_split("${input}" "\n" ";" )
    return_ans(lines)
  endfunction()
