# removes the specifed range from the lst and returns remaining elements
function(list_without lst start_index end_index)

  list_normalize_index(${lst} -1)
  ans(list_end)

  list_slice(${lst} 0 ${start_index})
  ans(part1)
  list_slice(${lst} ${end_index} ${list_end})
  ans(part2)

  set(res ${part1} ${part2})
  return_ref(res)
endfunction()