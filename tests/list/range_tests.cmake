function(test)
## returns a complete cmake range if the specified range is valid
## a cmake range is built up the following way: RANGE <begin> <end> <increment> 
function(range)
    string(REPLACE ":" ";" "range" "${ARGN}")
    list(APPEND range $ $ $)
    list(GET range 0 begin)
    list(GET range 1 increment)
    list(GET range 2 end)
    if("${begin}" STREQUAL RANGE)
      return(${ARGN})
    elseif("${begin}" STREQUAL "$")
      set(begin *)
    endif()
    if("${end}" STREQUAL "$")
      set(end ${increment})
      set(increment 1)
      if("${end}" STREQUAL "$")
        if("${begin}" STREQUAL "*")
          set(end "*")
        elseif("${begin}" LESS 0)
          math(EXPR end "0 ${begin} + 1")
        else()
          math(EXPR end "${begin} + 1")
        endif()
      endif()
      # this code would automatically invert the increment if the range is starts with a higher index than it ends
      #if("${end}" LESS "${begin}" OR "${begin}" STREQUAL "*")
      #  set(increment -1)
      #endif()
    endif()
    ## invalid range
    if((${end} LESS ${begin} AND ${increment} GREATER 0) OR (${end} GREATER ${begin} AND ${increment} LESS 0))
      return()
    endif()


    return(RANGE ${begin} ${end} ${increment})  
  endfunction()


  function(range_parse)

    string(REPLACE " " ";" range "${ARGN}")
    list(LENGTH range groups)

    set(ranges)
    if(${groups} GREATER 1)
      foreach(group ${range})
        range_parse("${group}")
        ans(current)
        list(APPEND ranges "${current}")
      endforeach()
      return_ref(ranges)
    endif()

    if(${groups} EQUAL 0)
      set(range "n:n:1")
    endif()


    if("${range}" STREQUAL ":")
      set(range "0:$:1")
    endif()
    
    string(REPLACE  ":" ";" range "${range}")
    

    list(LENGTH range part_count)
    if(${part_count} EQUAL 1)
      set(range ${range} ${range} 1)
    endif()

    if(${part_count} EQUAL 2)
      list(APPEND range 1)
    endif()

    list(GET range 0 begin)
    list(GET range 1 end)
    list(GET range 2 increment)



    if((${end} LESS ${begin} AND ${increment} GREATER 0) OR (${end} GREATER ${begin} AND ${increment} LESS 0))
      return()
    endif()

    if(${begin} STREQUAL -0)
      set(begin $)
    endif()

    if(${end} STREQUAL -0)
      set(end $)
    endif()

    if(${begin} LESS 0)
      set(begin "$${begin}")
    endif()
    if(${end} LESS 0)
      set(end "$${end}")
    endif()

    return(${begin}:${end}:${increment})
  endfunction()



  range_parse("")
  ans(res)
  assert(${res} EQUALS  n:n:1)

  range_parse(":")
  ans(res)
  assert(${res} EQUALS  0:$:1)

  range_parse("$")
  ans(res)
  assert(${res} EQUALS  $:$:1)

  range_parse("n")
  ans(res)
  assert(${res} EQUALS n:n:1)

  range_parse("1")
  ans(res)
  assert(${res} EQUALS  1:1:1)

  range_parse("1:3")
  ans(res)
  assert(${res} EQUALS  1:3:1)

  range_parse("3:1")
  ans(res)
  assert(${res} ISNULL)

  range_parse("1:3:-1")
  ans(res)
  assert(${res} ISNULL)

  range_parse("1;2;3")
  ans(res)
  assert(${res} EQUALS  1:1:1  2:2:1  3:3:1)

  range_parse("1:3 6:4:-1 2 9:4:3 : $")
  ans(res)
  assert(${res} EQUALS  1:3:1  6:4:-1  2:2:1  0:$:1  $:$:1)

  range_parse("-0")
  ans(res)
  assert(${res} EQUALS  $:$:1)

  range_parse("-1:-3:-1")
  ans(res)
  assert(${res} EQUALS  $-1:$-3:-1)


  function(range_instanciate length)
    range_parse(${ARGN})
    ans(range)
    math(EXPR last "${length}-1")

    set(result)
    foreach(part ${range})
      string(REPLACE : ";" part ${part})
      set(part ${part})
      list(GET part 0 begin)
      list(GET part 1 end)
      list(GET part 2 increment)

      if("${end}" MATCHES "\\$|n")
        string(REPLACE "n" "${length}" end "${end}")
        string(REPLACE "$" "${last}" end "${end}")
        math(EXPR end "${end}")
        if(${end} LESS 0)
          message(FATAL_ERROR "invalid range end: ${end}")
        endif()
      endif()

      if("${begin}" MATCHES "\\$|n")
        string(REPLACE "n" "${length}" begin "${begin}")
        string(REPLACE "$" "${last}" begin "${begin}")
        math(EXPR begin "${begin}")
        if(${begin} LESS 0)
          message(FATAL_ERROR "invalid range begin: ${begin}")
        endif()
      endif()

      list(APPEND result "${begin}:${end}:${increment}")  
    endforeach()

    return_ref(result)
  endfunction()

  range_instanciate(9 n/4:n*3/4)
  ans(res)
  assert(${res} EQUALS 2:6:1)

  range_instanciate(9 n/2)
  ans(res)
  assert(${res} EQUALS 4:4:1)

  range_instanciate(9 $+1)
  ans(res)
  assert(${res} EQUALS 9:9:1)

  range_instanciate(9 n)
  ans(res)
  assert(${res} EQUALS 9:9:1)


  range_instanciate(9 $)
  ans(res)
  assert(${res} EQUALS 8:8:1)

  range_instanciate(9 -1)
  ans(res)
  assert(${res} EQUALS 7:7:1)

  range_instanciate(9 -1:-5:-1)
  ans(res)
  assert(${res} EQUALS 7:3:-1)

  range_instanciate(1 1)
  ans(res)
  assert(${res} EQUALS 1:1:1)

  range_instanciate(3 :)
  ans(res)
  assert(${res} EQUALS 0:2:1)

  function(range_indices length)
    range_instanciate("${length}" ${ARGN})
    ans(range)
    set(indices)

    foreach(partial ${range})
      string(REPLACE ":" ";" partial "${partial}")
      foreach(i RANGE ${partial})
        list(APPEND indices ${i})
      endforeach() 
    endforeach()
    return_ref(indices)
  endfunction()


  range_indices("0" 1)
  ans(res)
  assert(${res} EQUALS 1)

  range_indices("4" :)
  ans(res)
  assert(${res} EQUALS 0 1 2 3)

  range_indices("0" 1 9 7 3 5)
  ans(res)
  assert(${res} EQUALS 1 9 7 3 5)

  range_indices("0" 9:6:-1 10:13 6 4)
  ans(res)
  assert(${res} EQUALS 9 8 7 6 10 11 12 13 6 4)

  range_indices("5" $:0:-1 $ :)
  ans(res)
  assert(${res} EQUALS 4 3 2 1 0 4 0 1 2 3 4)  

  timer_start(timer)
  range_indices(1000 : : : :)
  ans(res)
  timer_print_elapsed(timer)
  list(LENGTH res len)
  assert(${len} EQUALS 4000)



  function(list_range_get lst)
    list(LENGTH ${lst} len)
    range_indices("${len}" ${ARGN})
    ans(indices)
    list(LENGTH indices len)
    if(NOT len)
      return()
    endif()
    list(GET ${lst} ${indices} res)
    return_ref(res)
  endfunction()


  set(listA 0 1 2 3 4 5 6 7 8 9 a b c d e f)


  list_range_get(listA :)
  ans(res)
  assert(${res} EQUALS 0 1 2 3 4 5 6 7 8 9 a b c d e f)

  list_range_get(listA $:0:-1)
  ans(res)
  assert(${res} EQUALS f e d c b a 9 8 7 6 5 4 3 2 1 0)

  list_range_get(listA n/4:n*3/4)
  ans(res)
  assert(${res} EQUALS 4 5 6 7 8 9 a b c)

  list_range_get(listA 11 10 13 15 0 0 13)
  ans(res)
  assert(${res} EQUALS b a d f 0 0 d)

  function(range_partial_unpack ref)
    if(NOT ${ref})
      set(${ref} ${ARGN})
    endif()
    set(partial ${${ref}})
    string(REPLACE ":" ";" parts ${partial})
    list(GET parts 0 begin)
    list(GET parts 1 end)
    list(GET parts 2 increment)
    if("${end}${begin}" MATCHES "^[0-9]+$")
      math(EXPR count "${end} - ${begin}")
      math(EXPR length "${count} + 1")
    else()
      set(count "${end} - ${begin}")
      set(length "${end} - ${begin} + 1")
    endif()

    set(${ref}.begin ${begin} PARENT_SCOPE)
    set(${ref}.end ${end} PARENT_SCOPE)
    set(${ref}.increment ${increment} PARENT_SCOPE)
    set(${ref}.count  ${count} PARENT_SCOPE)
    set(${ref}.length  ${length} PARENT_SCOPE)
  endfunction()


  range_partial_unpack(uut "1:3:1")
  assert(${uut.begin} EQUALS 1)
  assert(${uut.end} EQUALS 3)
  assert(${uut.count} EQUALS 2)
  assert(${uut.length} EQUALS 3)
  assert(${uut.increment} EQUALS 1)



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
    list(LENGTH ${__lst} len)
    range_indices(${len} "${range}")
    ans(indices)
    list(LENGTH indices len)
    if(NOT len)
      return()
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


  return()
  function(list_range_replace __lst range)
    list(LENGTH ${__lst} len)

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

  set(lstB a b c)
  list_range_replace(lstB ":")
  ans(res)
  assert(${res} EQUALS a b c)
  assert(${lstB} ISNULL)


  set(lstB a b c d e)
  list_range_replace(lstB "1:4")
  ans(res)
  assert(${res} b c d)
  assert(${lstB} EQUALS a e)


  set(lstB)
  list_range_replace(lstB "n" a)
  ans(res)
  assert(${res} ISNULL)
  assert(${lstB} EQUALS a)

  set(lstB)
  list_range_replace(lstB "" b)
  ans(res)
  assert(${res} ISNULL)
  assert(${lstB} EQUALS b)



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