function(test)
set(b 0 1 2 3)

  
  list_split_first(a b b)  
  assert(${a} EQUAL 0)
  assert(EQUALS ${b} 1 2 3)

  list_split_first(a b b)  
  assert(${a} EQUAL 1)
  assert(EQUALS ${b} 2 3)

  list_split_first(a b b)
  assert(${a} EQUAL 2)
  assert(EQUALS ${b} 3)

  list_split_first(a b b)
  assert(${a} EQUAL 3)
  assert(NOT b)

endfunction()