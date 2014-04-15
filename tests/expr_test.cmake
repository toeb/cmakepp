function(test)  


#return()
  file(READ "${package_dir}/resources/expr.json" string_data)
  json_deserialize(oo-cmake-expr "${string_data}")

  file(READ "${package_dir}/resources/json-language.json" string_data)
  json_deserialize(json-language "${string_data}")


  function(ast_json_eval_string ast scope)
    map_get(${ast} data data)
    return_ref(data)
  endfunction()
  function(ast_json_eval_number ast scope)
    map_get(${ast} data data)
    return_ref(data)
  endfunction()
  function(ast_json_eval_boolean ast scope)
    map_get(${ast} data data)
    return_ref(data)
  endfunction()
  function(ast_json_eval_null ast scope)
    map_get(${ast} data data)
    return()
  endfunction()
  function(ast_json_eval_value_list ast scope)
    map_get(${ast} children children)
    ref_get(${children} children)
    set(values)
    foreach(child ${children})
      ast_eval(${child} ${scope})
      ans(value)
      list(APPEND values ${value})
    #  message("value ${value}")
    endforeach()

    return_ref(values)
  endfunction()
   function(ast_json_eval_key_value_list ast scope)

    map_get(${ast} children children)
    ref_get(${children} children)
    foreach(child ${children})
      ast_eval(${child} ${scope})
    endforeach()

  endfunction()
  function(ast_json_eval_array ast scope)
    map_get(${ast} children children)
    ref_get(${children} value_list)
   # message("array ${value_list}")
    ast_eval("${value_list}" ${scope})

    return_ans()
  endfunction()
  function(ast_json_eval_key_value ast scope)
    map_get(${ast} children children)
    ref_get(${children} value)
    list_pop_front(key value)
    ast_eval(${key} ${scope})
    ans(key)
    ast_eval(${value} ${scope})
    ans(value)

    #message("keyvalue ${key}:${value}")
    map_set(${scope} ${key} ${value})
  endfunction()
  function(ast_json_eval_object ast scope)
    map_create(map)
    map_get(${ast} key_value_list children)
    ref_get("${key_value_list}" key_value_list)
    ast_eval("${key_value_list}" ${map})    
    return(${map})
  endfunction()
  
  #evaluate("{\"asd\":\"val\"}" ${json-language} "object")
  #evaluate("{\"muu\":33,\"my2\":44,\"my3\":[1, 3]}" ${json-language} "json")
  file(READ "${package_dir}/resources/test.json" string_data)
evaluate("${string_data}" ${json-language} "json")
 
  ans(res)
  ref_print(${res})
  message("res ${res}")

return()
  #evaluate("\"hello\\\"from json\"" ${json-language} "value")
  evaluate("${string_data}" ${json-language} "json")
  ans(res)
  message("evaluated: ${res}")

return()
  evaluate("'asdf'" ${oo-cmake-expr} "rvalue")
  ans(res)
  message("res ${res}")

return()

function(ast_eval_rvalues ast scope)
 # message(called_eval_rvalues)
  map_tryget(${ast} children children)
  ref_get(${children} children)
 # message("children ${children}")
  set(elements)

  foreach(child ${children})
    ast_eval(${child} ${scope})
    ans(element)
    list(APPEND elements ${element})
  endforeach()
 #   message("elements: ${elements}")
  return_ref(elements)
endfunction()
function(ast_eval_array ast scope)
 # message("called eval array")
 # ref_print(${ast})
  map_tryget(${ast} children children)
  ref_get(${children} children)
  ast_eval(${children} ${scope})
  return_ans()
endfunction()

function(ast_eval_function_call ast scope)
  message("ast_eval_function_call called")
endfunction()
  
function(ast_eval_invokation ast scope)
  map_get(${ast} arguments children)
  ref_get(${arguments} arguments)
  list_pop_front(invokation_target arguments)

 # ref_print(${scope})
 # message("args: ${arguments}")
  ast_eval(${invokation_target} ${scope})
  ans(evaluated_invokation_target)
  ast_eval(${arguments} ${scope})
  ans(evaluated_arguments)

 # message(${evaluated_arguments})
 # message(${evaluated_invokation_target})

  # invoke
  eval("${evaluated_invokation_target}(${evaluated_arguments})")
  return_ans()
endfunction()
function(ast_eval_bind ast scope)
  message("bind called")
  map_get(${ast} children children)
  ref_get(${children} identifier)
  list_pop_front(rvalue identifier)

  ast_eval(${rvalue} ${scope})
  ans(new_scope)
  ast_eval(${identifier} ${new_scope})
  return_ans()
endfunction()

map_create(a_map)
map_set(${a_map} "property" "abcdf")
evaluate("a_map.property" "bind")
ans(res)
message("${res}")
return()


  function(test_func )
    message("argn ${ARGN}")
    return("wot")
  endfunction()
  set(test_func test_func)

evaluate("test_func(1,2,3,4)" "invokation" "test_func")
ans(theres)
assert("${theres}" STREQUAL "wot")
return()
  function(test_func )
    message("argn ${ARGN}")
    return("wot")
  endfunction()
  set(test_func test_func)
  evaluate("test_func(1,2,3,4)" "rvalue" "test_func")
return()

evaluate("{1,2,3,4,'huhuhuhu'}" "array")
ans(res)
message("hasd ${res}")
return()
message("${res}")
return()
evaluate("myval= 'huhu'")
assert(${myval} STREQUAL "huhu")


return()
evaluate("'muu'" "rvalue")
ans(res)
assert("${res}" STREQUAL "muu")

message(${res})


return()
  set(test_val huhu)
  evaluate("test_val" "rvalue" test_val)
  ans(res)
  message("${res}")
return()
  ast("hell_ooo" rvalue)
  ans(ast)
  ast_eval(${ast} ${scope})
  
  ref_print(${ast})

  return()
  ast("'asd','bsd'")
  ans(res)
  ref_print(${res})
  return()

  ast("  'asd','bsd','csd'")
  ans(res)
  ref_print(${res})
  return()


  ast("'asd'")
  ans(res)
  assert(DEREF "{res.data}" STREQUAL "asd")
  assert(DEREF "{res.type}" STREQUAL "single_quote_string")

  ast("\"bsd\"")
  ans(res)
  assert(DEREF "{res.data}" STREQUAL "bsd")
  assert(DEREF "{res.type}" STREQUAL "double_quote_string")

  ast("431")
  ans(res)
  assert(DEREF "{res.data}" EQUAL 431)
  assert(DEREF "{res.type}" STREQUAL "integer")

  ast("    'hello'  ")
  ans(res)
  assert(DEREF "{res.data}" STREQUAL "hello")


  

 # ref_print("${res}")
  return()
  expr_ast("    'asd'")
  expr_ast("\"asd\"")
  expr_ast("('asd'('bsd'))")


  return()
  ans(tokens)
  assert(EQUALS ${tokens} "'a\\'sd'") 

  expr_tokenize("\"asd\"")
  ans(tokens)
  assert(EQUALS ${tokens} "\"as\\\"d\"")
return()
  function(expr_ast str)
    string_semicolon_encode("${str}")
    ans(str)

    string_nested_split("${str}" "\(" "\)")
    ans(groups)

    list_length(groups)
    ans(length)

    message("${groups} - length ${length}")
    element(LIST)
      
    if("${length}" GREATER 1)
        foreach(group ${groups})
          expr_tokenize("${group}")
        endforeach()
    endif()
    element(END ast)
    

    ref_print(${ast})
    return(${ast})

  endfunction()

  expr_ast("")
  expr_ast("asd.bsd.functioncall(asd;'basd';csd['asd'][ea[32]];functioncall('asd';wew))[asd['asd']].dasd")
  #return()
  return()

  function(normalize_path path)
    string_semicolon_encode("${path}")
    ans(path)

    string_nested_split("${path}" "[" "]")
    ans(parts)


    message("${parts}")
  endfunction()


  normalize_path("asd.bsd.functioncall(asd;'basd';csd['asd'][ea[32]];functioncall('asd';wew))[asd['asd']].dasd")

# … elispis
# † selection start
# ‡ seelectio end

 


#return()



  list_set(testlist -1 a)
  list_set(testlist -1 b)
  list_set(testlist -1 c)
  list_set(testlist -2 d)

  assert(EQUALS ${testlist} a b d)

  expr_assignment_isvalid("'asd=cds'")
  ans(res)
  assert(NOT res)

  expr_assignment_isvalid("\"asd=cds\"")
  ans(res)
  assert(NOT res)

  expr_assignment_isvalid("\"asd=cds\"=asdasd")
  ans(res)
  assert(res)


  map_create(scope)
  expr_assign_lvalue("just_a_var" 2 ${scope})
  assert(DEREF "{scope.just_a_var}" STREQUAL "2")


  map_create(scope)
  expr_assign_lvalue(a.b.c 3 ${scope})
  assert(DEREF "{scope.a.b.c}" STREQUAL "3")

  expr_assign_lvalue(a.bb.c 4 ${scope})
  assert(DEREF "{scope.a.bb.c}" STREQUAL "4")
  
  expr_assign_lvalue(a[0].c 5 ${scope})
  assert(DEREF "{scope.a.b.c}" STREQUAL 5)

  expr_assign_lvalue("a['lol with spaces']" 6 ${scope})
 # todo: assert()

  map_create(scope)
  expr_assign_lvalue(just_a_var "a;b;c;d" ${scope})
  expr_assign_lvalue(just_a_var[2] "k" ${scope})
  assert(DEREF EQUALS "{scope.just_a_var}" a b k d )

  map_create(scope)
  expr_assign_lvalue(just_another_var "a;b;c" ${scope})
  expr_assign_lvalue(just_another_var[-1] "a;b;c" ${scope})

  assert(DEREF EQUALS "{scope.just_another_var}" a b c a b c)



  #ref_new(myref)
  #map_set(${scope} myref ${myref})
  #expr_assign_lvalue("myref" 2 ${scope})
  #ref_get(${myref} res)
  #assert(${res} STREQUAL "2")


  #map_create(scope)
  #function(doithwithref)
  #  message("doin it")
  #  return(${myref})
  #endfunction()
  #expr_assign_lvalue("*doithwithref()" 3 ${scope})
  #ref_get(${myref} res)
  #assert(${res} STREQUAL "3")

  #function(index_comp i j)
  #  math(EXPR res "${i}*10+${j}")
  #  return(${res})
  #endfunction()
  #map_create(scope)
  #expr_assign_lvalue("justavar" 4 ${scope})

  #expr_assign_lvalue("a.path.to.a.var" 4 ${scope})
 # expr_assign_lvalue("[0].path['string  key'][2][index_comp(3;4)]" 4 ${scope})



 # assert(DEREF "{scope.justavar}" STREQUAL 4)


  map_create(exports)
  expr_assignment("a = 'd'" ${exports}) 
  ref_print(${exports})
  map_create(exports)
  expr_assignment("a = b = 'c'" ${exports})
  ref_print(${exports})
  map_create(exports)
  expr_assignment("c.d= d.e = 'c'" ${exports})
  ref_print(${exports})
  map_create(exports)

  map_create(themap)
  function(fuu mp)
    map_set(${mp} test 1)
    return(${mp})
  endfunction()

  expr_assignment("[fuu(themap)].test2 = 2" ${exports})
  ref_print(${themap})



#return()



  functioN(fuuu)

  endfunction()

  expr(fuuu)
  ans(res)
  assert(COMMAND "${res}")



  function(hello)
    return(${ARGN} mumumu)
  endfunction()
  set(asd  a b c d)
  expr_call("hello(asd;'bsd')")
  ans(res)

  assert(EQUALS ${res} a b c d bsd mumumu)


  expr_call_isvalid("hello.asd[3].bsd()")
  ans(res)
  assert(res)

  expr_call_isvalid("hello.asd[3].bsd")
  ans(res)
  assert(NOT res)




  expr_integer_isvalid("asd")
  ans(res)
  assert(NOT res)

  expr_integer_isvalid("1")
  ans(res)
  assert(res)

  expr_integer_isvalid("-1")
  ans(res)
  assert(res)

  expr_integer_isvalid("0")
  ans(res)
  assert(res)

  expr_integer_isvalid("1b")
  ans(res)
  assert(NOT res)

expr(3)
ans(res)
assert("${res}" EQUAL 3)

expr(-3)
ans(res)
assert("${res}" EQUAL -3)

expr(0)
ans(res)
assert("${res}" EQUAL 0)



expr_indexer_isvalid("bsd")
ans(res)
assert(NOT res)

expr_indexer_isvalid("asd[]")
ans(res)
assert(NOT res)

expr_indexer_isvalid("asd[3]")
ans(res)
assert(res)
expr_indexer_isvalid("asd[0]")
ans(res)
assert(res)

expr_indexer_isvalid("asd[-3]")
ans(res)
assert(res)

expr_indexer_isvalid("asd['asdasd asd']")
ans(res)
assert(res)



expr_indexer_isvalid("asd[\"asdasd asd\"]")
ans(res)
assert(res)




expr_navigate_isvalid("a")
ans(res)
assert(NOT res)

expr_navigate_isvalid("")
ans(res)
assert(NOT res)

expr_navigate_isvalid("a.b")
ans(res)
assert(res)

  expr()
  ans(res)
  assert("${res}_" STREQUAL "_")


  expr("'just a string'")
  ans(res)
  assert("${res}" STREQUAL "just a string")

  expr("\"another string\"")
  ans(res)
  assert("${res}" STREQUAL "another string")


  set(var "'ello gov'ner")
  expr("var")
  ans(res)
  assert("${res}" STREQUAL "'ello gov'ner" )

  ref_new(myref)
  ref_set(${myref} "greetings")
  expr("myref")
  ans(res)
  assert("${res}" STREQUAL "${myref}")

  expr("*myref")
  ans(res)
  assert("${res}" STREQUAL "greetings")

  expr("*myref;var;'asd';\"bsd\"")
  ans(res)
  assert(EQUALS ${res} "greetings" "'ello gov'ner" "asd" "bsd")

  string_remove_ending("asdasd bsd" "bsd")
  ans(res)
  assert(${res} STREQUAL "asdasd ")

  nav(a.b 33)
  nav(a.c.d 44)
expr("a.b")
ans(res)
assert("${res}" STREQUAL 33)

expr("a.c.d")
ans(res)
assert("${res}" STREQUAL  44)


expr_indexer("a['b']")
ans(res)
assert(${res} STREQUAL 33)


expr(a['c']['d'])
ans(res)
assert(${res} STREQUAL "44")

expr(a[0])
ans(res)
assert(${res} STREQUAL 33)


expr(a[1].d)
ans(res)
assert(${res} STREQUAL 44) 



  nav(a.b 33)
  expr("a.b")
  ans(res)
  assert("${res}" STREQUAL "33")



  

  string_nested_split("a b c" { })
  ans(res)
  assert(COUNT 1 ${res})
  assert(EQUALS ${res} "a b c")

  string_nested_split("{}" { })
  ans(res)
  assert(EQUALS ${res} {})

  string_nested_split("{asd}" { })
  ans(res)
  assert(EQUALS ${res} {asd})

  string_nested_split("{{}}" { })
  ans(res)
  assert(EQUALS ${res} {{}})

  string_nested_split("{{} {}}" { })
  ans(res)
  assert(EQUALS ${res} "{{} {}}")

  string_nested_split("{} {}" { })
  ans(res)
  assert(EQUALS ${res} "{}" " " "{}")


  string_nested_split("{} {} {{} {{} {}}}" { })
  ans(res)
  assert(EQUALS ${res} "{}" " " "{}" " " "{{} {{} {}}}")


  string_nested_split("{{} {}}" { })
  ans(res)
  assert(COUNT 1 ${res})
  assert(EQUALS ${res} "{{} {}}")


  string_nested_split("{{}}" { })
  ans(res)
  assert(COUNT 1 ${res})
  assert(EQUALS ${res} "{{}}")

  

  string_nested_split("{a b c}" { })
  ans(res)
  assert(COUNT 1 ${res})
  assert(EQUALS ${res} "{a b c}")

  string_nested_split("{a}{b}" { })
  ans(res)
  assert(COUNT 2 ${res})
  assert(EQUALS ${res} {a} {b})

  string_nested_split("{a} {b}" { })
  ans(res)
  assert(COUNT 3 ${res})
  assert(EQUALS ${res} {a} " " {b})






endfunction()