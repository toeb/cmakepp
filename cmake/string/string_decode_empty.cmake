# decodes an encoded empty string
function(string_decode_empty str) 
  if("${str}" STREQUAL "↔")
    return("")
  endif()
  return_ref(str)
endfunction()