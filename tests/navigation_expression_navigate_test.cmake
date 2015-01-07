function(test)

  function(navigation_expression_parse)
    string(REPLACE "." ";" expression "${ARGN}")
    string(REPLACE "[" ";[" expression "${expression}")
    return_ref(expression)
  endfunction()


  navigation_expression_parse("a.b.c")
  ans(res)
  assert(${res} EQUALS a b c)

  navigation_expression_parse("a.b[3].c")
  ans(res)
  assert(${res} EQUALS a b [3] c)

  navigation_expression_parse("a.b[3][34].c")
  ans(res)
  assert(${res} EQUALS a b [3] [34] c)

  navigation_expression_parse("[1]")
  ans(res)
  assert(${res} EQUALS [1])

  navigation_expression_parse("[]")
  ans(res)
  assert(${res} EQUALS [])

  navigation_expression_parse("[1][0]")
  ans(res)
  assert(${res} EQUALS [1] [0])

  navigation_expression_parse("[1]" "[0]")
  ans(res)
  assert(${res} EQUALS [1] [0])


  obj("{
    a:{
      b:{
        c:{
          d:123
        }
      }
    },
    e:[
     4,
     5,
     {
      f:{
        g:{
          h:789
        }
      }
     },
     6
    ]
  }")
  ans(a)


  set(b)
  set(c asdf)
  set(d asd bsd csd)
  set(e asd bsd ${a} fsd)

  function(print_vars)
    set(__str)
    foreach(arg ${ARGN})
      set(__str "${__str} ${arg}: '${${arg}}'")
    endforeach()
    message("${__str}")
  endfunction()



  function(navigation_expression_lvalue)
    navigation_expression_parse("${ARGN}")
    ans(expressions) 
    set(input ${expressions})

    list_peek_front(expressions)
    map_capture_new(${expressions})
    ans(current_ref)
    ans(current_value)
    set(current_property)
    set(current_range)
    


    while(true)
      list_pop_front(expressions)
      ans(current_expression)
      ## store wether the current iteration is the last iteration (length of expressions is 0 on last iteration)
      list(LENGTH expressions not_last)

      # store previous values
      set(previous_ref ${current_ref})
      set(previous_value ${current_value})


      set(is_range false)
      set(current_range ":")
      if("${current_expression}" MATCHES "^\\[.*\\]$")
        set(is_range true)
        string_slice("${current_expression}" 1 -2)
        ans(current_expression)
      endif()

      if(is_range)
        list_range_get(current_value "${current_expression}")
        ans(current_value)

      else()
        # is prop
        map_tryget("${current_value}" "${current_expression}")
        ans(current_value)
      endif()

      list(LENGTH current_value current_value_length)
      list(LENGTH previous_value previous_value_length)

      if(${current_value_length} EQUAL 0)
        set(current_is_lvalue false)
      elseif(${current_value_length} EQUAL 1)

      else()
        set(current_is_lvalue false)

      endif()



      print_vars(current_expression current_ref current_value current_value_length current_range is_range)




      ## break after last
      if(NOT not_last)
        break()
      endif()
    endwhile()

    message(POP)

    print_vars(input)

  endfunction()




  navigation_expression_lvalue(e)     # cmake_ref:'' val:'' ref:'' prop:'' range:''

  json_print(${e})
  return()
  navigation_expression_lvalue(e[2].a.b.c)     # cmake_ref:'' val:'' ref:'' prop:'' range:''
return()
  navigation_expression_lvalue(a.b.c)       # cmake_ref:''  val:'' ref:'${a.b}'  prop:'c' range: '[:]'
  navigation_expression_lvalue(a)           # cmake_ref:'a' val:'' ref:'' prop:'' range:'[0:$]'
  navigation_expression_lvalue(a.b)         # cmake_ref:'a' val:'' ref:'${a}' prop:'b' range: [:]
  navigation_expression_lvalue(a[0])        # cmake_ref:'a' val:'' ref:'' prop:'' range: [0]
  navigation_expression_lvalue(a.b[0])      # cmake_ref:'a' val:'' ref:'${a}' prop:'b' range:'[0]'
  navigation_expression_lvalue(a.e[2].f.g)  # cmake_ref:''  val:'' ref:'${a.e[2].f}' prop:'g' range:'[:]'
  navigation_expression_lvalue(a.e[2])      # cmake_ref:'a' val:'' ref:'${a}' prop:'e' range:'[2]'
  navigation_expression_lvalue(b.c)         # cmake_ref:'b' val:'' ref:'' prop:'c' range:'[:]'
  navigation_expression_lvalue(b)           # cmake_ref:'b' val:'' ref:'' prop:'' range:'[:]'
  navigation_expression_lvalue(c)           # cmake_ref:'c' val:'asdf' ref:'' prop:'' range:'[:]'
  navigation_expression_lvalue(c.a)         # cmake_ref:'c' val:'asdf' ref:'' prop:'a' range:'[:]'
  navigation_expression_lvalue(a.e[2 3].f.g) # cmake_ref:'' val:'' ref:'${a}' prop:'e' range:'[2 3]'
  navigation_expression_lvalue(d[2 3])       # cmake_ref:'d' val:'' ref:'' prop:'' range:''





return()

  function(navigation_expression_lvalue)
    navigtion_expression_parse(${ARGN})
    ans(expression)
    message("expression ${expression}")
    

  endfunction()





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