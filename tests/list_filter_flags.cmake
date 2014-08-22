function(test)

  set(flags --a --b --c --d)
  list_filter_flags(flags --c --d --e)
  ans(res)
  assert(EQUALS ${res} --c --d)


  set(flags)
  list_filter_flags(flags --c --e)
  ans(res)
  assert(NOT res)


  list_filter_flags(flags)
  ans(res)
  assert(NOT res)

  set(flags --a --b --c)
  list_filter_flags(flags)
  ans(res)
  assert(NOT res)

endfunction()