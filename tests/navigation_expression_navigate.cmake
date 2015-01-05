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


  function(navigation_expression_lvalue)
    navigation_expression_parse("${ARGN}")
    ans(expression) 
    set(input ${expression})

    list_pop_front(expression)
    ans(cmake_ref)

    set(current_value "${${cmake_ref}}")
    map_isvalid("${current_value}")
    ans(isref)

    if(NOT isref)
      set(ref)
    else()
      set(cmake_ref)
      set(ref "${current_value}")
    endif()
    
    message(PUSH)
    while(true)
      list_pop_front(expression)
      ans(current_expression)
      list(LENGTH expression not_last)
      set(previous_value ${current_value})
      set(is_range false)
      set(range ":")
      if("${current_expression}" MATCHES "^\\[.*\\]$")
        set(is_range true)
        string_slice("${current_expression}" 1 -2)
        ans(range)
      endif()
      list(LENGTH previous_value len)
      range_instanciate(${len} "${range}")
      ans(range)
      string(REPLACE ":" ";" range "${range}")
      list(GET range 5 is_lvalue_range)
      if(is_lvalue_range EQUAL 1)
        set(is_lvalue_range true)
      else()
        set(is_lvalue_range false)
      endif()
      


      set(is_lvalue false)
      
      if(is_range)
        if(is_lvalue_range)
          set(is_lvalue)
        endif()
      else()
        map_isvalid(${current_value})
        ans(is_lvalue)
      endif()



      message("current_expression '${current_expression}' range:'${range}' isrange: '${is_range}' islvalue_range:'${is_lvalue_range}' previous_value:'${previous_value}' current_value:'${current_value}' is_lvalue: '${is_lvalue}'")

      ## break after last
      if(NOT not_last)
        break()
      endif()
    endwhile()

    message(POP)

    message("expression: '${input}' cmake_ref: '${cmake_ref}' val:'${val}' ref:'${ref}' prop:'${prop}' range:'${range}' ")

  endfunction()
  navigation_expression_lvalue(e[2].b.c)     # cmake_ref:'' val:'' ref:'' prop:'' range:''
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