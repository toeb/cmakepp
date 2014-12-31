function(test)

  function(cmake_range range)
    
  endfunction()

  set(var RANGE 1 10 2)
set(var)
  foreach(i ${var})
    message("i ${i}")
  endforeach()

 function(range_foreach)

 endfunction()




  return()



  function(list_range_unpack lst range)
    list(LENGTH ${lst} list_count)
    range_indices("${range}" "${list_count}")
    ans(indices)
    list(LENGTH indices index_count)
    set(${lst}.indices ${indices} PARENT_SCOPE)
    set(${lst}.index_count ${index_count} PARENT_SCOPE)
    set(${lst}.count ${list_count} PARENT_SCOPE)
  endfunction()



  set(lstA a b c d e f)
  list_range_unpack(lstA "2:3")
  assert(${lstA.index_count} EQUALS 2)
  assert(${lstA.count} EQUALS 6)
  assert(${lstA.indices} EQUALS 2 3)


  list_range_unpack(lstA "")
  assert(${lstA.index_count} EQUALS 0)
  assert(${lstA.count} EQUALS 6)
  assert(${lstA.indices} ISNULL)
  





  return()

  function(range_get lst range)
    list_range_unpack("${lst}" "${range}")

    if(NOT lst.index_count)
      return()
    endif()

    list(GET ${lst} ${lst.indices} result)
    return_ref(result)
  endfunction()



  set(lstA a b c d e f g h i j k l m n o p q r s t u v w x y z)

  
  range_get(lstA 1:3)
  ans(res)
  assert(${res} EQUALS b c d)

  range_get(lstA 5:4)
  ans(res)
  assert(${res} ISNULL)

  range_get(lstA "0:*")
  ans(res)
  assert(${res} EQUALS ${lstA})

  range_get(lstA "1:2:*")
  ans(res)
  assert(${res} EQUALS b d f h j l n p r t v x z)

  range_get(lstA "*:-1:0")
  ans(res)
  assert(${res} EQUALS z y x w v u t s r q p o n m l k j i h g f e d c b a)

return()
  range_get(lstA "")
  ans(res)
  assert(${res} ISNULL)



  function(range_set_each lst range value)
    list(LENGTH ${lst} itemCount)
    range_indices("${range}" ${itemCount})

  endfunction()

  ## remove the specified range from the list
  macro(range_remove lst range)
    list_range_unpack("${lst}" ${range})
    message("${${lst}.indices}")
    if(${lst}.indexCount)
      list(REMOVE_AT ${lst} ${${lst}.indices})
    endif()
  endmacro()

  # sets the values of specified range with the varargs passed. 
  # if there are less varags than elements to replace the rest of the elements
  # are set to null
  function(range_set lst range)
    list(LENGTH ${lst})

  endfunction()

  set(lstA a b c d e f g h i j k l m n o p q r s t u v w x y z)
  range_remove(lstA "0:2:*")

  assert(${lstA} EQUALS b d f h j l n p r t v x z)

return()


  set(lstA a b c d e f g h i j k l m n o p q r s t u v w x y z)

  range_get(lstA "")
  ans(res)
  assert(${res} ISNULL)

  range_get(lstA 1:3)
  ans(res)
  assert(${res} EQUALS b c d)

  range_get(lstA 5:4)
  ans(res)
  assert(${res} ISNULL)

  range_get(lstA "0:*")
  ans(res)
  assert(${res} EQUALS ${lstA})

  range_get(lstA "1:2:*")
  ans(res)
  assert(${res} EQUALS b d f h j l n p r t v x z)

  range_get(lstA "*:-1:0")
  ans(res)
  assert(${res} EQUALS z y x w v u t s r q p o n m l k j i h g f e d c b a)




  return()


  function(navigation_expression_navigate current)
    set(path)
    set(args ${ARGN})
    foreach(expr ${args})
      navigation_expression_unpack(expr)
      if(expr.is_property)
        set(last_map ${current})
        set(last_prop ${expr.property})
        set(last_range ${expr.range})

        map_tryget(${current} ${expr.property})
        ans(current)
        if("${current}_" STREQUAL "_")
          break()
        endif()
        list(APPEND path ${expr.property})
      elseif(expr.is_range)

        # if range is assignable
        set(last_range ${expr.range})

      endif()



    endforeach()
    list(LENGTH path len)
    list_slice(args "${len}" "*")
    ans(rest)
    list_pop_front(rest)
    set(lvalue ${last_map} ${last_prop} ${last_range})
    message("last lvalue is ${lvalue}")
    message("path is ${path}")
    message("rest is ${rest}")
  endfunction()


  obj("{a:{b:{c:3}},b:{c:{}},c:['a',{b:{d:'asd'}},4 ,{e:{f:{g:'bsd'}}}]}")
  ans(uut)
  navigation_expression_navigate(${uut})
  navigation_expression_navigate(${uut} a b c)
  navigation_expression_navigate(${uut} b c d)
  navigation_expression_navigate(${uut} a b e d)
  navigation_expression_navigate(${uut} c [1] b d e f)


endfunction()