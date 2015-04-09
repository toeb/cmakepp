function(test)

  ## runtime tests
  obj("{
    a:{
      b:{
        c:[1,2]
        },
      d:[3,4]
    },
    e:[
      {a:5},
      {a:6}
    ],
    f:7,
    g:8
  }")
  ans(the_object)



  define_test_function2(test_uut expr "interpret_indexation" "")

  set(the_list a b c)

  ## property indexation, multi index indexation, multi property select
  test_uut("5;6" "$the_object.e[0,1]...['a']")
  ## successive property indexation
  test_uut("3;4" "$the_object['a']['d']")
  ## successive property and mulit index indexation
  test_uut("4;3" "$the_object['a']['d'][1,0]")
  ## proeprty indexation
  test_uut("7" "$the_object['f']")
  ## multi property indexation
  test_uut("7;8" "$the_object['f','g']")
  ## multi property indexation
  test_uut("2;1" "{a:1,b:2}['b','a']")
  ## mulit index indexation
  test_uut("c;b;d;a" "[a,b,c,d][2,1,3,0]")
  ## single index indexation
  test_uut("b" "$the_list[1]")
  ## mulit index indexation
  test_uut("c;a;b" "$the_list[2,0,1]")


  set(exception "{'__$type__':'exception'}")
  ##### compile time tests #####


  define_test_function2(test_uut expr "interpret_indexation" "--ast")

  ## invalid token count
  test_uut("${exception}")
  ## wrong token
  test_uut("${exception}" a)
  ## empty
  test_uut("{expression_type:'indexation'}" "a[]")
  ## simple string literal
  test_uut("{expression_type:'indexation'}" "a['abc']")
  ## number literal
  test_uut("{expression_type:'indexation'}" "a[1]")






return()



  


return()
  ## interpret assign

function(alal)
  map_new()
  ans(asd)
  map_set(${asd} lol 123)
  return(${asd})
endfunction()
  obj("{b:{c:2}}")
  ans(a)
  expr(interpret_assign "--print-code" "$a.b.c = alal().lol")
  ans(res)
  assert("${res}" STREQUAL 123)
  assertf("{a.b.c}" STREQUAL 123)

return()
  set(a)
  expr(interpret_assign "" "$a = 1")
  ans(res)
  assert("${res}" EQUAL 1)
  assert("${a}" EQUAL 1)


return()


  ## intepret statements
  define_test_function2(test_uut expr interpret_statements "")

  expr(interpret_statements "" "a;b")
  ans(res)
  assert("${res}" STREQUAL b)


  expr(interpret_statements "" "a;b;c")
  ans(res)
  assert("${res}" STREQUAL c)

  test_uut("${exception}")
  test_uut("" "")
  test_uut("a" "a")











  return()





  function(interpret_range tokens)
    list_select_property(tokens type)
    ans(token_types)
    list_remove(token_types number dollar colon minus comma)
    if(token_types)
      throw("unexpected token types" --function interpret_range)
    endif()


    
    
    ast_new(
      "${tokens}"         # tokens
      "range"             # expression_type
      ""                  # value_type
      ""                  # ref
      ""                  # code
      ""                  # value
      ""                  # const
      ""                  # pure_value
      ""                  # children
      )
    ans(ast)


    return()
    throw("not implemented")

  endfunction()

  define_test_function2(test_uut expr "interpret_range" "--ast")


  ## invlaid token
  test_uut("${exception}" abc)

#  test_uut("${exception}")


  return()




endfunction()