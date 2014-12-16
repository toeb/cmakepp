function(test)

  string_isnumeric("asva")
  ans(res)
  assert(NOT res)

  string_isnumeric("123")
  ans(res)
  assert(res)

  string_isnumeric(0)
  ans(res)
  assert(res)

  string_isnumeric("1231023")
  ans(res)
  assert(res)

endfunction()