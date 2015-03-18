
function(cmakelists_targets cmakelists target_name )
  map_tryget(${cmakelists} range)
  ans(range)
  cmake_token_range_targets_filter("${range}" "${target_name}")
  return_ans()
endfunction()