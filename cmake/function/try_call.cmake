
function(try_call)
  set(args ${ARGN})
  list_pop_front(args)
  ans(func)
  is_function(is_func "${func}")
  if(is_func)
    return()
  endif()
  call(${ARGN})
  return_ans()
endfunction()