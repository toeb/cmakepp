function(test)

  process_list()
  ans(res)
  #json_print(${res})
  list(LENGTH res len)
  assert(${len} GREATER 1)

endfunction()