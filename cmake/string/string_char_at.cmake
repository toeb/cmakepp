# returns the character @ index of input string
# negative values less than -1 are translated into length - |index|
function(string_char_at index input)
  string(LENGTH "${input}" len)
  string_normalize_index("${input}" ${index})
  ans(index)
  if("${index}" LESS 0 OR ${index} EQUAL "${len}" OR ${index} GREATER ${len}) 
    return()
  endif()
  string(SUBSTRING "${input}" ${index} 1 res)
  return_ref(res)

endfunction()