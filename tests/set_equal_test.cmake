function(test)





  set(nullSet)
  set(oneSet a)
  set(setA a b c)
  set(setB a b c)
  set(setC a b )


  set_equal(nullSet nullSet)
  ans(res)
  assert(res)

  set_equal(oneSet nullSet)
  ans(res)
  assert(NOT res)

  set_equal(oneSet oneSet)
  ans(res)
  assert(res)

  set_equal(setA setB)
  ans(res)
  assert(res)

  set_equal(setB setC)
  ans(res)
  assert(NOT res)




 function(set_normalize theset)


 endfunction()




endfunction()