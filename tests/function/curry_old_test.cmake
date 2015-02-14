function(test)


  function(funcA a b c)
    return("${a}${b}${c}")
  endfunction()


  curry3(funcB => funcA(/0 44 /1))
  funcB("1" "2")
  ans(res)
  assert("${res}" STREQUAL 1442)

  
  curry3(funcB() => funcA(/1 nana /0))
  funcB("1" "2")
  ans(res)
  assert("${res}" STREQUAL 2nana1)

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


  # test fails on cmake 3.0.1  ...
  if(false)
    curry3(() => funcA(/0 ] [))
    ans(res)
    call(${res}(1))
    ans(res)
    assert("${res}" STREQUAL "1][")
endif()


endfunction()