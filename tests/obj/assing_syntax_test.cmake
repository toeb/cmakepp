function(test)


  #event_addhandler(on_exception "[](ex) print_vars(ex)")

  define_test_function2(test_uut eval_expr2 interpret_literal "")

  ## literal test
  test_uut("{'__$type__':'exception'}")
  test_uut("" "")
  test_uut("a" "a") 
  test_uut("" "''") 
  test_uut("" "\"\"") 
  test_uut("a b c" "a b c") ## sepearated arg
  test_uut("a" "'a'") 
  test_uut("a" "\"a\"") 
  test_uut("{'__$type__':'exception'}" a b) # => error only single token allowed
  test_uut("123" "123")
  test_uut("true" "true")
  test_uut("false" "false")
  test_uut("" "null")
  test_uut("null" "'null'")
  test_uut("abc def" "abc def")
  test_uut("{'__$type__':'exception'}" "[") # => error  invalid token
  test_uut("{'__$type__':'exception'}" ,) # => error  invalid token



  
  define_test_function2(test_uut eval_expr2 interpret_literals "")

  ## literals test
  test_uut("{'__$type__':'exception'}") # no token => excpetion
  test_uut("abc" a b c)
  test_uut("abc d" 'a' \"b\" "c d")
  test_uut("{'__$type__':'exception'}" 'a' ( \"b\" "c d")) #invalid tokens




  ## scope rvalue

  define_test_function2(test_uut eval_expr2 interpret_scope_rvalue "")

  set(the_var 123)

  set(the_other_var)

  test_uut("{'__$type__':'exception'}") ## no tokens
  test_uut("{'__$type__':'exception'}" "the_other_var") ## no dollar symbol
  test_uut("{'__$type__':'exception'}" "$") ## no identifier or paren
  test_uut("" "$[the_other_var]") ## ok - no value
  test_uut("" "$(the_other_var)") ## ok - no value
  test_uut("" "$the_other_var") ## ok - no value
  test_uut("" "$'the_other_var'") ## ok - no value
  test_uut("" "$\"the_other_var\"") ## ok - no value
  test_uut("123" "$the_var")
  test_uut("123" "$(the_var)") ## ok
  test_uut("123" "$[the_var]") ## ok
   # test_uut("123" "$.the_var") ## ok should be ok

  ## navigation rvalue
  obj("{
    b:1,
    c:{
      d:2,
      e:[
        {f:3},
        {g:4},
        5,
        6,
        {h:7}
      ]
    },
    i:[8,9,10],
    j:{},
    k:[]
  }")
  ans(a)
  
  define_test_function2(test_uut eval_expr2 interpret_navigation_rvalue "")

  test_uut("{'__$type__':'exception'}")
  test_uut("{'__$type__':'exception'}" "a") # too few tokens
  test_uut("{'__$type__':'exception'}" "[abc]") # too few tokens
  test_uut("{'__$type__':'exception'}" "abc" "abc") # missing dot
  test_uut("{'__$type__':'exception'}" ".abc") # no lvalue 
  test_uut("" "a.abc") # ok 
  test_uut("" "a[abc]") # ok 
  test_uut("1" "$a.b") 
  test_uut("1" "$a[b]") 
  test_uut("1" "$a['b']") 
  test_uut("1" "$a[\"b\"]") 
  test_uut("2" "$a.c.d")
  test_uut("2" "$a[c][d]")
  test_uut("2" "$[a][c][d]")
  test_uut("8;9;10" "$a.i")



  define_test_function2(test_uut eval_expr2 interpret_call "")
  


return()
  eval_expr2("literals" "" a b c d)
  ans(res)





  return()
  eval_expr2("$asd = 83838")
  eval_expr2("$asd = 83838")

  eval_expr2("message(hell)")
  
  message("hahahah ${asd}")



  return()
#  string_codes_print()

  function(test_tokenize)
    arguments_tokenize(0 ${ARGC})
    print_vars(tokens token_types --plain)
  endfunction()

  # regression for token index indicator
 # test_tokenize("[f1(b,k),c,a,f(123)]")

  function(test_expression type first)
    expression("${type}" "${first}" ${ARGN})
    ans(res)
    map_tryget("${res}" result)
    ans(res)
    map_tryget("${res}" code)
    ans(code)
    _message("${code}")    
    return_ref(res)
  endfunction()

  obj("{b:{c:'lol'}}")
  ans(a)
  timer_start(t1)
  compile_expr2(testf interpret_navigation_rvalue "$a.b.c")
  timer_print_elapsed(t1)

  timer_start(t1)
  testf()
  ans(asd)
  timer_print_elapsed(t1)
  assert(${asd} STREQUAL "lol")

  return()
   define_test_function(test_uut test_expression type first)

   test_uut("{}" interpret_navigation_rvalue "a.b")
   test_uut("{}" interpret_navigation_rvalue "$a[test(abc)]")

 return()
   test_uut("{}" interpret_bracket "$a[a]")
return()
   test_uut("{}" interpret_navigation_rvalue "$a.b.c")
   test_uut("{}" interpret_navigation_rvalue "$a.b[1:2,3:4,5:1:-1]")

   test_uut("{}" interpret_bracket "[f1(b,k),c,a,f(123)]")

return()
   test_uut("{}" interpret_call "abc(def(ghi(),jkl()),mno())")

  test_uut("{}" interpret_call abc ( 123, 123, "asd asd" , asd ))
   test_uut("{}" interpret_paren "(a,'b   a',c)")


return()


   test_uut("{}" interpret_paren "(asd,123,234"  "345)")

return()
   test_uut("{}" interpret_paren (asd, 123 , 234\ 345))

   test_uut("{}" interpret_literal "23")


return()
   test_uut("{}" interpret_scope_rvalue "$abc")
  test_uut("{}" interpret_literals "123 234")


return()

return()

  test_uut("{}" "interpret_assign" "$a = b")





  return()

  test_uut("{result:{type:'composite_string', code:'abc'}}" "interpret_literals" "a b c")
  test_uut("{result:{type:'number', code:'123'}}" interpret_literals "123")
  test_uut("{result:{type:'composite_string', code:'123abc123'}}" interpret_literals "123" "a" 'b' \"c123\")

  test_uut("{result:''}" "interpret_literal" "")
  test_uut("{result:{type:'unquoted_string'}}" "interpret_literal" "a")
  test_uut("{result:{type:'single_quoted_string'}}" "interpret_literal" "'a'")
  test_uut("{result:{type:'double_quoted_string'}}" "interpret_literal" "\"a\"")
  test_uut("{result:{type:'number'}}" "interpret_literal" 123)
  test_uut("{result:{type:'null'}}" "interpret_literal" null)
  test_uut("{result:{type:'bool'}}" "interpret_literal" true)
  test_uut("{result:{type:'bool'}}" "interpret_literal" false)

  test_uut("{result:{type:'list'}}" "interpret_bracket" "[a,b,c,d]") 

  function(interpret_parens tokens)

    return()
  endfunction()

  function(interpret_scope_var tokens)
    if(lhs)
      return()
    endif()

    endfunction()
  function(interpret_navigation tokens)
    if("${tokens}" MATCHES "^dollar")

    endif()
    returN()
  endfunction()


  test_uut("{result:{type:'lvalue'}}" interpret_lvalue "$a")



  test_uut("true" interpret_assign "$a = b")




  function(intepret_expression tokens)
    ## reset lhs
    set(lhs)

    interpret_literals("${tokens}")
    ans(literal)

    interpret_parens("${tokens}")
    ans(parens)

    interpret_scope_var("${tokens}")
    ans(scope_var)





    
  endfunction()
  function(interpret_value tokens)

  endfunction()

  test_uut("{}" "interpret_scope_var" "$a.b")



  return()
  
  function(test_tokenize_types)
    timer_start(tokenize_time)
    tokenize(${ARGN})
    if(token_types)
      list(GET type_list ${token_types} token_names)
    endif()

    timer_print_elapsed(tokenize_time)
    message("tokens ${tokens} :: ${token_types}")
    print_vars(tokens token_types error --plain)
    return_ref(token_names)
  endfunction()





  function(interpret_statements  tokens types)
    if(inside_statement)
      return()
    endif()
    set(inside_statement true)
    list(LENGTH tokens length)
    math(EXPR last_index "${length} - 1")
    if(NOT length)
      return()
    endif()

    message(statement)

    set(current_statement_tokens)
    set(current_statement_types)
    set(statements)
    foreach(i RANGE 0 ${last_index})
      list(GET types ${i} type)
      list(GET tokens ${i} token)
      
      if("${type}" MATCHES "^(semicolon)|(newline)$")
        message(PUSH)
          interpret_expression("${current_statement_tokens}" "${current_statement_types}")
          ans_append(statements)
        message(POP)
      endif()
      list(APPEND current_statement_tokens ${token})
      list(APPEND current_statement_types ${type})
    endforeach()
    
    message(PUSH)
    interpret_expression("${current_statement_tokens}" "${current_statement_types}")
    ans_append(statements)
    message(POP)


    set(code)
    foreach(ast ${statements})
      map_tryget("${ast}" code)
      ans(current_code)
      set(code "${code}${current_code}")
    endforeach()

    map_new()
    ans(ast)
    map_set("${ast}" code "${code}")
    return_ref(ast)
  endfunction()



  function(interpret_nesting  token type)
    if(NOT "${types}" MATCHES "^((paren)|(brace)|(bracket))$")
      return()
    endif()

    map_import_properties("${token}" tokens types nesting_type)


    return()
  endfunction()

  function(interpret_cmake_var  tokens types)
    if(NOT "${types}" MATCHES "^dollar;")
      return()
    endif()

    list(GET tokens 1 identifier)
    list(GET types 1 identifier_type)
    interpret_literal("${identifier}" "${identifier_type}")
    ans(literal)


    if(NOT literal)
      message(FATAL_ERROR "invalid syntax. expected literal after asterisk")
      return()
    endif()

    map_new()
    ans(ast)
    map_set("${ast}" argument true)
    map_set("${ast}" static false)
    map_set("${ast}" type ref)
    map_set("${ast}" code "\${}")

    return(ast)
  endfunction()  


  function(interpret_bracket tokens types)
    list(LENGHT tokens token_count)
    math(EXPR last_index "${token_count} - 1" )
    
    set(current_indices)
    foreach(i RANGE 0 ${last_index})
      list(GET types ${i} type )
      if("${type}" MATCHES "^((separation)|(comma))$")

      endif()
    endforeach()

  endfunction()

  function(interpret_expression tokens)
    list(LENGTH tokens token_count)
    print_Vars(tokens types token_count)

    # interpret_statements("${tokens}" "${types}")
    # ans(ast)
    # if(ast)
    #   return(${ast})
    # endif()

    interpret_nesting("${tokens}" "${types}")
    ans(ast)
    if(ast)
      return(${ast})
    endif()

    interpret_literal("${tokens}" "${types}")
    ans(ast)
    if(ast)
      return(${ast})
    endif()

    interpret_bracket("${tokens}" "${types}")
    ans(ast)
    if(ast)
      return(${ast})
    endif()
    
    interpret_cmake_var("${tokens}" "${types}")
    ans(ast)
    if(ast)
      return(${ast})
    endif()
    messaGE("not found")
    return()

  endfunction()





  test_uut("" interpret_literal "asd" )

return()
  test_uut("['string', 'hello']" "hello")
  test_uut("['string', 'hello']" hello)
  test_uut("['string', 'hello']" \"hello\")
  test_uut("['string', '$']" '$')
  test_uut("['string', '^']" '^')
  test_uut("['string', 'false']" \"false\")
  test_uut("['string', 'true']" \"true\")
  test_uut("['string', 'null']" \"null\")
  test_uut("['string', 123]" \"123\")
  test_uut("['bool', 'true']" true)
  test_uut("['bool', 'false']" false)


  test_uut("array_or_indexer" "[asd ]")

  #test_uut("null" null ) does not work even though values match
  #test_uut("string;" '') testuut does nto work here

  
  #this fails
  #test_uut("['string', ' ']" ' ')




  define_test_function(test_uut test_tokenize_types)

  return()

  test_uut("unquoted;separation;unquoted" "a" "b")
  test_uut("number" 0)
  test_uut("number" 1)
  test_uut("number" 12)
  test_uut("unquoted" a)
  test_uut("unquoted" ab)
  test_uut("unquoted" \ )
  test_uut("quoted" "\"a\"" )
  test_uut("quoted" "\"!@#$%^&*()_|\\\"\\\\/~{[]} \n\"" )
  test_uut("char" '')
  test_uut("char" "' '")
  test_uut("exclamation_mark;at;hash;dollar;modulo;zirkumflex;ampersand;asterisk;paren_open;paren_close;bracket_open;bracket_close;brace_open;brace_close;pipe;slash;tilde" "!@#$%^&*()[]{}|/~")




  timer_start(t1)
  foreach(i RANGE 0 100)
    eval_math("123+${i}")
    ans(asd)
  endforeach()
  timer_print_elapsed(t1)




  timer_start(t1)
  foreach(i RANGE 0 100)
    eval_expr2("$asd = eval_math('123+${i}')")
  endforeach()
  timer_print_elapsed(t1)



  timer_start(t1)
  foreach(i RANGE 0 100)
    eval_expr2("$asd = eval_math('123+${i}')")
  endforeach()
  timer_print_elapsed(t1)

endfunction()