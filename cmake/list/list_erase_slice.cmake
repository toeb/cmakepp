

# removes the specified range from lst and returns the removed elements
function(list_erase_slice lst start_index end_index)
  list_slice(${lst} ${start_index} ${end_index})
  ans(res)
  list_without(${lst} ${start_index} ${end_index})
  ans(rest)
  set(${lst} ${rest} PARENT_SCOPE)
  return_ref(res)
endfunction()



