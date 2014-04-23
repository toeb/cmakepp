function(quick_map_serialize map)
  #todo
  stack_new(thestack)
  curry(stack_push("${thestack}" /1) __qms_push)
  curry(stack_pop("${thestack}") __qms_pop)
  ref_new(__qms_result)
  function(__qms_expand node)
    if(ismap)

    endif()
  endfunction()
  graph_search(${map} PUSH __qms_push POP __qms_pop EXPAND __qms_expand)

endfunction()
function(quick_map_deserialize quick_map_string)
  eval("${quick_map_string}")
  return_ans()
endfunction()