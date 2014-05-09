function(val)
  # appends the values to the current_map[current_key]
  stack_peek(:quick_map_map_stack)
  ans(current_map)
  stack_peek(:quick_map_key_stack)
  ans(current_key)
  if(NOT current_map)
    set(res ${ARGN})
    return_ref(res)
  endif()
  map_append("${current_map}" "${current_key}" "${ARGN}")
endfunction()