# fails if list contains more or less than a single value
function(list_single lst)
  list(LENGTH ${lst} len)
  if(NOT ${len} EQUAL 1)
    message(FATAL_ERROR "expected list to be a single element")
  endif()
  return_ref(${lst})
endfunction()