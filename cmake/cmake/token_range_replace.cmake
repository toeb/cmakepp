
function(token_range_replace start end replace_start replace_end)
  
  map_tryget(${start} previous)
  ans(previous)
  map_set(${previous} next ${replace_start})
  map_set(${replace_start} previous ${previous})
  map_set(${end} previous ${replace_end})
  map_set(${replace_end} next ${end})
endfunction()