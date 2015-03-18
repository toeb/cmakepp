function(test)


  

  set(lstA a b c)
  set(valA 1)
  set(valB 2)
  set(lstB d e f)
  set(valC)

  eval_predicate(valA STREQUAL 1)
  ans(res)
  assert(res)
  
  eval_predicate(valA STREQUAL 2)
  ans(res)
  assert(NOT res)

  eval_predicate(valB STREQUAL 2)
  ans(res)
  assert(res)

  eval_predicate(valC STREQUAL 3)
  ans(res)
  assert(NOT res)

  eval_predicate(NOT valC STREQUAL 3)
  ans(res)
  assert(res)

endfunction()