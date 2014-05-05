function(key key)
  # check if there is a current map
  stack_peek(:quick_map_map_stack)
  ans(current_map)
  if(NOT current_map)
    message(FATAL_ERROR "cannot set key for non existing map be sure to call first map() before first key()")
  endif()
  # set current key
  stack_pop(:quick_map_key_stack)
  stack_push(:quick_map_key_stack "${key}")
endfunction()