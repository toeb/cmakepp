function(test)

  process_list()
  ans(res)
  list(LENGTH res len)
  assert(${len} GREATER 1)

endfunction()