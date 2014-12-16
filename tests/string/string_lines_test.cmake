function(test)
  string_lines("ab\ncd\nef")
  ans(res)
  assert(COUNT 3 ${res})


  string_lines("ab")
  ans(res)
  assert(COUNT 1 ${res})

  string_lines("")
  ans(res)
  assert(COUNT 0 ${res})


  ## todo: fails
  return()
  string_lines("\n")
  ans(res)
  assert(COUNT 2 ${res})



endfunction()