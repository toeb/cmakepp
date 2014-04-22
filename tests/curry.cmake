function(test)

 

  function(funcA a b c)
    return("${a}${b}${c}")
  endfunction()

  curry(funcA(/2 nana /1) as funcB)
  funcB("1" "2")
  ans(res)
  assert("${res}" STREQUAL 2nana1)

  curry(funcA(/1 44 /2) as funcB)
  funcB("1" "2")
  ans(res)
  assert("${res}" STREQUAL 1442)

    function(funcC var1 var2)
      return("${var1}${var2}${var3}${var4}")
    endfunction()
    set(var3 3)
    set(var4 4)

    bind(funcC var3 var4 as funcB)

    set(var3 5)
    set(var4 6)


    funcB(1 2)
ans(res)
assert("${res}" STREQUAL "1234")


endfunction()