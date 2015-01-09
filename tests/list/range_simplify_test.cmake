function(test)




  range_simplify(9 "[1:$-1]" "[2:5]" "[$:0:-1]")
  ans(res)
  assert(${res} EQUALS "[6:3:-1]")











endfunction()