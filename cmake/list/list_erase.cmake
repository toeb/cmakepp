
# removes the specified range from lst
function(list_erase lst start_index end_index)
  list_without(${lst} ${start_index} ${end_index})
  ans(res)
  set(${lst} ${res} PARENT_SCOPE)
  return_ref(res)
endfunction()