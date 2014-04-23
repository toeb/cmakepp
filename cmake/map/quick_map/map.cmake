function(map)
  set(key ${ARGN})

  # get current map
  stack_peek(ref:quick_map_map_stack)
  ans(current_map)

  # get current key
  stack_peek(ref:quick_map_key_stack)
  ans(current_key)

  if(ARGN)
    set(current_key ${ARGV0})
  endif()

  # create new current map
  map_new()
  ans(new_map)


  # add map to existing map
  if(current_map)
    key("${current_key}")
    val("${new_map}")
  endif()


  # push new map and new current key on stacks
  stack_push(ref:quick_map_map_stack ${new_map})
  stack_push(ref:quick_map_key_stack "")

  return_ref(new_map)
endfunction()