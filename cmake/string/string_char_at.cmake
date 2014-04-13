# returns the character @ index of input string
function(string_char_at result index input)
  string(LENGTH "${input}" len)
  string_normalize_index("${input}" ${index})
  ans(index)
  if("${index}" LESS 0 OR ${index} EQUAL "${len}" OR ${index} GREATER ${len}) 
    set(${result} PARENT_SCOPE)
    return()
  endif()
  string(SUBSTRING "${input}" ${index} 1 res)
  set(${result} "${res}" PARENT_SCOPE)
  return_ref(res)

  ans(index)
  message("string_char_at ${len} , ${index}")

  math(EXPR end "${index} + 1")
  string_slice("${input}" ${index} ${end})
  ans(res)
  set(${result} "${res}" PARENT_SCOPE)
  return_ref(res)

  return_value(${res})
  string_normalize_index("${input}" ${index})
  ans(index)

  message("index ${index}")
	string(LENGTH "${input}" len )
	if(${len} EQUAL 0)
		return_value()
	endif()
	


	string(SUBSTRING "${input}" ${index} 1 char)
	return_value(${char})
endfunction()