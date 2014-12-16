function(test)
  
  string_isempty("")
  ans(res)
  assert(res)


  string_isempty("false")
  ans(res)
  assert(NOT res)


  string_isempty("no")
  ans(res)
  assert(NOT res)

  string_isempty("abc")
  ans(res)
  assert(NOT res)


endfunction()