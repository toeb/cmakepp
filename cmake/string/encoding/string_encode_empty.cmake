# encodes an empty element
function(string_encode_empty str)
  string_codes()

  string(ASCII 24 empty_code)
  if("_${str}" STREQUAL "_")
    return("${empty_code}")
  endif()
  return_ref(str)
endfunction()




