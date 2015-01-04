function(test)
  






  function(list_range_indices __lst)
    list(LENGTH ${__lst} len)
    range_indices("${len}" ${ARGN})
    ans(indices)
    return_ref(indices)
  endfunction()




  ## sets the specified range to the specified values returns all values
  ## which were not used
  function(list_range_set __lst range)
    set(args ${ARGN})
    list_range_indices(${__lst} "${range}")
    ans(indices)
    foreach(i ${indices})
      list_pop_front(args)
      ans(current)
      list(INSERT "${__lst}" "${i}" "${current}")
      math(EXPR i "${i} + 1")
      list(REMOVE_AT "${__lst}" "${i}")
    endforeach()
    set(${__lst} ${${__lst}} PARENT_SCOPE)
    return_ref(args)
  endfunction()

  set(lstB ${listA})
  list_range_set(lstB "0:$:2" + + + + + + + + + + )
  ans(res)
  assert(${res} EQUALS + +)
  assert(${lstB} EQUALS + 1 + 3 + 5 + 7 + 9 + b + d + f)

  set(lstB ${listA})
  list_range_set(lstB "0:$:2")
  ans(res)
  assert(${res} ISNULL)
  assert(${lstB} EQUALS 1 3 5 7 9 b d f)







  function(list_range_remove __lst range)
    list(LENGTH ${__lst} list_len)
    range_indices(${list_len} "${range}")
    ans(indices)
    list(LENGTH indices len)

    if(NOT len)
      return(0)
    endif()
    #message("${indices} - ${list_len}")
    if("${indices}" EQUAL ${list_len})
      return(0)
    endif()
    list(REMOVE_AT ${__lst} ${indices})
    set(${__lst} ${${__lst}} PARENT_SCOPE)
    return(${len})
  endfunction()


  set(lstB ${listA})
  list_range_remove(lstB "1:4 6:10 12:$")
  ans(res)
  assert(${res} EQUALS 13)
  assert(${lstB} EQUALS 0 5 b)

  set(lstB ${listA})
  list_range_remove(lstB ":")
  ans(res)
  assert(${res} EQUALS 16)
  assert(${lstB} ISNULL)

  set(lstB ${listA})
  list_range_remove(lstB $)
  ans(res)
  assert(${res} EQUALS 1)
  assert(${lstB} EQUALS 0 1 2 3 4 5 6 7 8 9 a b c d e)


  set(lstB ${listA})
  list_range_remove(lstB "")
  ans(res)
  assert(${res} EQUALS 0)
  assert(${lstB} EQUALS 0 1 2 3 4 5 6 7 8 9 a b c d e f)

  ## replaces the specified range with the specified arguments
  ## 1:3 replaces 1 2
  ## 1:$ replaces 1 2 ... $-2 $-1
  ## 1:n replaces 1 2 ... $
  ## 3:1 replaces 3 2 1 
  ## $:0 replaces $ ... 0

  function(list_range_replace lst_ref range)
    set(lst ${${lst_ref}})

    list(LENGTH lst len)
    range_instanciate(${len} "${range}")
    ans(range)

    set(replaced)
    message("inputlist '${lst}' length : ${len} ")
    message("range: ${range}")
    set(difference)

    range_indices("${len}" ":")
    ans(indices)
    
    range_indices("${len}" "${range}")
    ans(indices_to_replace)
    
    list(LENGTH indices_to_replace replace_count)
    message("indices_to_replace '${indices_to_replace}' count: ${replace_count}")

    math(EXPR replace_count "${replace_count} - 1")

    if(${replace_count} LESS 0)
      message("done\n")
      return()
    endif()

    set(args ${ARGN})
    set(replaced)

    message(PUSH)
    foreach(i RANGE 0 ${replace_count})
      list(GET indices_to_replace ${i} index)

      list_pop_front(args)
      ans(current_value)

      #if(${i} EQUAL ${replace_count})
      #  set(current_value ${args})
      #endif()

      if(${index} GREATER ${len})
        message(FATAL_ERROR "invalid index '${index}' - list is only ${len} long")
      elseif(${index} EQUAL ${len}) 
        message("appending to '${current_value}' to list")
        list(APPEND lst "${current_value}")
      else()
        list(GET lst ${index} val)
        list(APPEND replaced ${val})
        message("replacing '${val}' with '${current_value}' at '${index}'")
        list(INSERT lst ${index} "${current_value}")
        #list(LENGTH current_value current_len)
        math(EXPR index "${index} + 1")
        list(REMOVE_AT lst ${index})
        message("list is now ${lst}")
      endif()



    endforeach()
    message(POP)


    message("lst '${lst}'")
    message("replaced '${replaced}'")
    message("done\n")
    set(${lst_ref} ${lst} PARENT_SCOPE)
    return_ref(replaced)
  endfunction()


  set(lstB)
  list_range_replace(lstB "")
  ans(res)
  assert(${res} ISNULL)
  assert(${lstB} ISNULL)

  set(lstB a b c)
  list_range_replace(lstB "")
  ans(res)
  assert(${res} ISNULL)
  assert(${lstB} EQUALS a b c)

  #       0 1 2 3
  set(lstB a b c )
  list_range_replace(lstB "*")
  ans(res)
  assert(${res} EQUALS a b c)
  assert(${lstB} ISNULL)

  #       0 1 2 3 4 5
  set(lstB a b c d e )
  list_range_replace(lstB "1:3")
  ans(res)
  assert(${res} EQUALS b c d)
  assert(${lstB} EQUALS a e)



  function(list_range_replace_slice lst_ref range)
    range_parse("${range}")
    ans(range)
    list(LENGTH range len)
    message("input_list '${${lst_ref}}'")

    set(removed)
    list_range_remove(${lst_ref} "${range}")
 

    message("range '${range}'")
    message("removed ${removed}")

    message("result_list '${${lst_ref}}'\n")

    return_ref(removed)
  endfunction()

  set(lstA a b c)
  list_range_replace_slice(lstA "")
  ans(res)

  set(lstA)
  list_range_replace_slice(lstA "" 1)
  ans(res)




  return_ref(removed)
  
  return()






  range()
  ans(res)
  assert(_ ${res} EQUALS _ RANGE * * 1)


  range(*)
  ans(res)
  assert(_ ${res} EQUALS _ RANGE * * 1)

  range(1)
  ans(res)
  assert(_ ${res} EQUALS _ RANGE 1 2 1)

  range(0)
  ans(res)
  assert(_ ${res} EQUALS _ RANGE 0 1 1)

  range(1:4)
  ans(res)
  assert(_ ${res} EQUALS _ RANGE 1 4 1)

  range(1:2:6)
  ans(res)
  assert(_ ${res} EQUALS _ RANGE 1 6 2)

  range(*:-3:*)
  ans(res)
  assert(_ ${res} EQUALS _ RANGE * * -3)

  range(RANGE 2 3 1)
  ans(res)
  assert(_ ${res} EQUALS _ RANGE 2 3 1)


  range(2:2)
  ans(res)
  foreach(i ${res})
    assert(${i} EQUALS 2)
  endforeach()

  range(3:2)
  ans(res)
  foreach(i ${res})
    assert(false)
  endforeach()


  range(3:-1:2)
  ans(res)
  set(lst)
  foreach(i ${res})
    list(APPEND lst ${i})
  endforeach()
  assert(${lst} EQUALS 3 2)


  range(3:1:2)
  ans(res)
  assert(NOT res)

  range(2:-1:3)
  ans(res)
  assert(NOT res)








endfunction()