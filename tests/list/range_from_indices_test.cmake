function(test)
  
  
  


  range_from_indices(1 2 3)
  ans(res)
  assert(${res} EQUALS [1:3])

  range_from_indices()
  ans(res)
  assert(${res} ISNULL)

  range_from_indices(3 2 1)
  ans(res)
  assert(${res} EQUALS [3:1:-1])


  range_from_indices(1)
  ans(res)
  assert(${res} EQUALS 1)

  range_from_indices(1 2)
  ans(res)
  assert(${res} EQUALS "1 2")

  range_from_indices(1 2 3 4 5 8)
  ans(res)
  assert(${res} EQUALS "[1:5] 8")



endfunction()