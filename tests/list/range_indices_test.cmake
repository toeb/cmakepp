function(test)


  range_indices("" 3)
  ans(res)
  assert(${res} ISNULL)

  range_indices("")
  ans(res)
  assert(${res} ISNULL)

  range_indices(1)
  ans(res)
  assert(${res} EQUALS 1 2)

  range_indices(1:2)
  ans(res)
  assert(${res} EQUALS 1 2)

  range_indices(2:4)
  ans(res)
  assert(${res} EQUALS 2 3 4)

  range_indices(2:2)
  ans(res)
  assert(${res} ISNULL)

  range_indices(3:2)
  ans(res)
  assert(${res} ISNULL)

  range_indices(4:1)
  ans(res)
  assert(${res} ISNULL)

  range_indices(*:1 3)
  ans(res)
  assert(${res} ISNULL)

  range_indices(0:3 4)
  ans(res)
  assert(${res} EQUALS 0 1 2 3)

  range_indices(0:2:5)
  ans(res)
  assert(${res} EQUALS 0 2 4)

  range_indices(5:-2:2)
  ans(res)
  assert(${res} EQUALS 5 3)

  range_indices(4:-1:1)
  ans(res)
  assert(${res}  EQUALS 4 3 2 1)

  range_indices(5:1:2)
  ans(res)
  assert(${res} ISNULL)

  range_indices(1:* 3)
  ans(res)
  assert(${res} EQUALS 1 2)

  range_indices(*:-1:1 3)
  ans(res)
  assert(${res} EQUALS 2 1)


endfunction()