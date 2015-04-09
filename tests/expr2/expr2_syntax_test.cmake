function(test)
  set(exception "{'__$type__':'exception'}")
  ##### runtime tests #####

  return()

  define_test_function2(test_uut eval_expr2 "interpret_rvalue_reference" "--ast")  
    
  ## no tokens
  test_uut("${exception}")
  ## no reference token
  test_uut("${exception}" abc)




  return()

  function(interpret_indexation tokens)
    list(LENGTH tokens token_count)
    if(NOT "${token_count}" EQUAL 1)
      throw("invalid token count, expected one token got ${token_count}" --function interpret_indexation)
    endif()

    map_tryget("${tokens}" type)
    ans(token_type)

    if(NOT "${token_type}" STREQUAL "bracket")
      throw("invalid token type, expected bracket but got ${token_type}" --function interpret_indexation)
    endif()

    map_tryget("${tokens}" tokens)
    ans(inner_tokens)

    interpret_elements("${inner_tokens}" "comma" "interpret_rvalue")
    ans(elements)

    message("elements: ${elements}")
    foreach(element ${elements})

    endforeach()



    ast_new(
      "${tokens}"         # tokens
      "indexation"        # expression_type
      ""                  # value_type
      ""                  # ref
      ""                  # code
      ""                  # value
      ""                  # const
      ""                  # pure_value
      "${children}"                  # children
      )
    ans(ast)
    return_ref(ast)
  endfunction()



  define_test_function2(test_uut eval_expr2 "interpret_indexation" "--ast")

  ## invalid token count
  test_uut("${exception}")
  ## wrong token
  test_uut("${exception}" a)
  ## empty
  test_uut("{expression_type:'indexation'}" "[]")
  ## simple string literal
  test_uut("{expression_type:'indexation'}" "['abc']")
  ## number literal
  test_uut("{expression_type:'indexation'}" "[1]")






return()



  define_test_function2(test_uut eval_expr2 "interpret_assign" "")
  event_addhandler(on_exception "[](ex) print_vars(ex)")
  
  test_uut("<{b:1}>1" "$['b'] = 1")


  test_uut("<{a:1}>1" "$a = 1")
  test_uut("<{a:2}>2" "$a = 2")
  test_uut("<{a:'abc'}>abc" "$a = abc")
  test_uut("<{a:'abc'}>abc" "$a = 'abc'")
  test_uut("<{a:'abc'}>abc" "$a = \"abc\"")



  return()


  #event_addhandler(on_exception "[](ex) print_vars(ex)")

  define_test_function2(test_uut eval_expr2 "interpret_assign" "--ast")


  ## no tokens
  test_uut("${exception}")
  ## wrong tokens
  test_uut("${exception}" 1 2 3)
  ## missing tokens
  test_uut("${exception}" "=")
  ## missing lhs
  test_uut("${exception}" "=1")
  ## missing rhs
  test_uut("${exception}" "$a=")
  ## invalid lvalue
  test_uut("${exception}" "a=b")
  ## invalid rvalue
  test_uut("${exception}" "$a=,")






  eval_expr2(interpret_literal "--ast" "a")
  ans(rvalue)

  define_test_function2(test_uut eval_expr2 "interpret_scope_lvalue" "--ast;${rvalue}")
 # event_addhandler(on_exception "[](ex) print_vars(ex)")

  ## no tokens
  test_uut("${exception}")
  ## not dollar token
  test_uut("${exception}" a)
  ## no identifier token 
  test_uut("${exception}" $)
  ## invalid identifier token
  test_uut("${exception}" "$,")
  ## valid
  test_uut("{expression_type:'scope_lvalue'}" "$b")
  


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
  eval_expr2(interpret_assign "--print-code" "$a.b.c = alal().lol")
  ans(res)
  assert("${res}" STREQUAL 123)
  assertf("{a.b.c}" STREQUAL 123)

return()
  set(a)
  eval_expr2(interpret_assign "" "$a = 1")
  ans(res)
  assert("${res}" EQUAL 1)
  assert("${a}" EQUAL 1)


return()


  ## intepret statements
  define_test_function2(test_uut eval_expr2 interpret_statements "")

  eval_expr2(interpret_statements "" "a;b")
  ans(res)
  assert("${res}" STREQUAL b)


  eval_expr2(interpret_statements "" "a;b;c")
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

  define_test_function2(test_uut eval_expr2 "interpret_range" "--ast")


  ## invlaid token
  test_uut("${exception}" abc)

#  test_uut("${exception}")


  return()




endfunction()