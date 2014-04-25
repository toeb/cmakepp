# encodes an empty element
function(string_encode_empty str)
  if("_${str}" STREQUAL "_")
    return("↔")
  endif()
  return_ref(str)
endfunction()
