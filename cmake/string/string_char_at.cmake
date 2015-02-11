## <%=markdown_template_function_header("(<index:int> <input:string>)-><char>")%>
##
## returns the character at the position specified. strings are indexed 0 based
## indices less than -1 are translated into length - |index|
##
## *Examples*
## ```cmake
## string_char_at(3 "abcdefg")  # => "d"
## string_char_at(-3 "abcdefg") # => "f"
## ```
##
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