function(test)


  ## indices [0,4)
  index_range(0 4)
  ans(res)

  ##square each value
  list_select(res "
    function(func i)
      return_math(\"\${i} * \${i}\")
    endfunction()")
  ans(squared)


  assert(${squared} EQUALS 0 1 4 9)

endfunction()