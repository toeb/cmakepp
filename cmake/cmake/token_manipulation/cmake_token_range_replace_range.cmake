## `()-><void>`
## 
## replaces the specified range with the specified replace range
function(cmake_token_range_replace_range range replace_range)
  list_extract(range start end)
  list_extract(replace_range replace_start replace_end)
  map_tryget(${start} previous)
  ans(previous)
  map_set(${previous} next ${replace_start})
  map_set(${replace_start} previous ${previous})
  map_set(${end} previous ${replace_end})
  map_set(${replace_end} next ${end})
  return()
endfunction()