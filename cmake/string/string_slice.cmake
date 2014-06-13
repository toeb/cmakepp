# extracts a portion of the string negative indices translatte to count fromt back
function(string_slice str start_index end_index)
  # indices equal => select nothing

  string_normalize_index("${str}" ${start_index})
  ans(start_index)
  string_normalize_index("${str}" ${end_index})
  ans(end_index)

  if(${start_index} LESS 0)
    message(FATAL_ERROR "string_slice: invalid start_index ")
  endif()
  if(${end_index} LESS 0)
    message(FATAL_ERROR "string_slice: invalid end_index")
  endif()
  # copy array
  set(result)
  math(EXPR len "${end_index} - ${start_index}")
  string(SUBSTRING "${str}" ${start_index} ${len} result)

  return_ref(result)
endfunction()
  