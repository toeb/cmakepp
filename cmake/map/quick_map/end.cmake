function(end)
  # remove last key from key stack and last map from map stack
  # return the popped map
  stack_pop(ref:quick_map_key_stack)
  stack_pop(ref:quick_map_map_stack)
  return_ans()
endfunction()
