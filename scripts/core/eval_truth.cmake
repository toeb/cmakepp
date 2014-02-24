

# evaluates a truth expression 'if' and returns true or false 
function(eval_truth result)
  if(${ARGN})
    return_value(true)
  else()
    return_value(false)
  endif()

endfunction()