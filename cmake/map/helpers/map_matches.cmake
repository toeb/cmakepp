
# returns a function which returns true of all 
function(map_matches attrs)
  obj("${attrs}")
  ans(attrs)
  curry(map_match_properties(/1 ${attrs}))
  return_ans()
endfunction()


