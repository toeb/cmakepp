function(test)
  set(exception "{'__$type__':'exception'}")


  ##### compile time tests ######

  define_test_function2(test_uut eval_expr2 interpret_literal "--ast")

  ## 1 token required
  test_uut("${exception}") 
  ## only single token
  test_uut("${exception}" a b) 
  ## unquoted empty string
  test_uut("{expression_type:'literal', value_type:'unquoted_string', value:''}" "") 
  ## single sepearted token
  test_uut("{expression_type:'literal', value_type:'unquoted_string', value:'a'}" "a") 
  ## single separated token with space
  test_uut("{expression_type:'literal', value_type:'unquoted_string', value:'a\\\\ b'}" "a b") 
  ## single single quoted token 
  test_uut("{expression_type:'literal', value_type:'single_quoted_string', value:'a'}" "'a'") 
  ##  single double quoted token 
  test_uut("{expression_type:'literal', value_type:'double_quoted_string', value:'a'}" "\"a\"") 
  ## number
  test_uut("{expression_type:'literal', value_type:'number', value:'123'}" "123") 
  ## bool, true  
  test_uut("{expression_type:'literal', value_type:'bool', value:'true'}" "true") 
  ## bool, false
  test_uut("{expression_type:'literal', value_type:'bool', value:'false'}" "false") 
  ## null
  test_uut("{expression_type:'literal', value_type:'null', value:''}" "null") 



  define_test_function2(test_uut eval_expr2 interpret_literals "--ast")
  ## no token
  test_uut("${exception}") 
  ## single unquoted empty string
  test_uut("{expression_type:'literal', value_type:'unquoted_string', value:''}" "") 
   ## single unquoted string
  test_uut("{expression_type:'literal', value_type:'unquoted_string', value:'a'}" a) 
  ## two unquoted strings are concatenated
  test_uut("{expression_type:'literals', value_type:'composite_string', value:'ab'}" a b) 
  ## two nummbers are concatenated
  test_uut("{expression_type:'literals', value_type:'composite_string', value:'12'}" 1 2) 



  ##  interpret elements
  define_test_function2(test_uut eval_expr2 interpret_elements "--ast;comma;interpret_literals")


  ## invalid token
  test_uut("${exception}" "$")  
  ## no token 
  test_uut("")  
  ## single valid token 
  test_uut("{expression_type:'literal'}" a)  
  ## single multi token element
  test_uut("{ expression_type:'literals', value:'ab' }" a b)  
  ## multi single token elements
  test_uut("[{ expression_type:'literal', value:'a'},{expression_type:'literal',value:'b'}]" a , b)  
  ## multi single token elements
  test_uut("[{ expression_type:'literals', value:'ab'},{ expression_type:'literals', value:'cd'}]" a b, c d)  



  define_test_function2(test_uut eval_expr2 interpret_list "--ast")

  # invalid too few tokens
  test_uut("${exception}")
  # invalid too many tokens
  test_uut("${exception}" 1 2) 
  # invalid right amout of tokens but wrong type
  test_uut("${exception}" 1)
  # empty list
  test_uut("{expression_type:'list',children:''}" "[]")
  # single element list
  test_uut("{expression_type:'list',children:[{value:'a'}]}" "[a]")
  # multi element list
  test_uut("{expression_type:'list',children:[{value:'a'},{value:'b'}]}" "[a,b]")


  define_test_function2(test_uut eval_expr2 interpret_paren "--ast")


  ## too few tokens
  test_uut("${exception}")
  ## too many tokens
  test_uut("${exception}" 1 2)
  ## right amount tokens but wrong type
  test_uut("${exception}" 1)
  ## right token empty paren is invalid 
  test_uut("${exception}" "()")
  ## right token empty expression in paren is invalid 
  test_uut("${exception}" "(,)")
  ## ok literal inner expression
  test_uut("{expression_type:'paren', children:{value:'a'}}" "(a)")


  define_test_function2(test_uut eval_expr2 interpret_ellipsis "--ast")

  ## no tokens fails
  test_uut("${exception}")
  ## wrong tokens fails
  test_uut("${exception}" 1 2 3 4)
  ## no rvalue 
  test_uut("${exception}" "...")
  ## illegal rvalue 
  test_uut("${exception}" ",...")
  ## ok
  test_uut("{expression_type:'ellipsis', children:{value:'a'}}" "a...")
  ## ok
  test_uut("{expression_type:'ellipsis', children:{children:[{value:'a'},{value:'b'}]}}" "[a,b]...")


  ##### runtime tests #####

  #event_addhandler(on_exception "[](ex) print_vars(ex)")

  define_test_function2(test_uut eval_expr2 interpret_literal "")

  ## literal test
  test_uut("${exception}")
  test_uut("${exception}" a b) # => error only single token allowed
  test_uut("${exception}" "[") # => error  invalid token
  test_uut("${exception}" ,) # => error  invalid token
  test_uut("" "")
  test_uut("a" "a") 
  test_uut("" "''") 
  test_uut("" "\"\"") 
  test_uut("a b c" "a b c") ## sepearated arg
  test_uut("a" "'a'") 
  test_uut("a" "\"a\"") 
  test_uut("123" "123")
  test_uut("true" "true")
  test_uut("false" "false")
  test_uut("" "null")
  test_uut("null" "'null'")
  test_uut("abc def" "abc def")



  define_test_function2(test_uut eval_expr2 interpret_literals "")

  ## literals test

  # no token => exception
  test_uut("${exception}") 
  test_uut("abc" a b c)
  test_uut("abc d" 'a' \"b\" "c d")
  test_uut("${exception}" 'a' ( \"b\" "c d")) #invalid tokens

  ## scope rvalue

  define_test_function2(test_uut eval_expr2 interpret_scope_rvalue "")

  set(the_var 123)

  set(the_other_var)

  test_uut("" "$[the_other_var]") ## ok - no value

  test_uut("${exception}") ## no tokens
  test_uut("${exception}" "the_other_var") ## no dollar symbol
  test_uut("${exception}" "$") ## no identifier or paren
  test_uut("" "$(the_other_var)") ## ok - no value
  test_uut("" "$the_other_var") ## ok - no value
  test_uut("" "$'the_other_var'") ## ok - no value
  test_uut("" "$\"the_other_var\"") ## ok - no value
  test_uut("123" "$the_var")
  test_uut("123" "$[the_var]") ## ok
  test_uut("123" "$(the_var)") ## ok
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
  
  define_test_function2(test_uut eval_expr2 interpret_navigation_rvalue "--print-code")
  test_uut("2" "$a.c.d")
  test_uut("1" "$a.b") 

  test_uut("${exception}")
  test_uut("${exception}" "a") # too few tokens
  test_uut("${exception}" "[abc]") # too few tokens
  test_uut("${exception}" "abc" "abc") # missing dot
  test_uut("${exception}" ".abc") # no lvalue 
  test_uut("" "a.abc") # ok 
  test_uut("" "a[abc]") # ok 
  test_uut("1" "$a[b]") 
  test_uut("1" "$a['b']") 
  test_uut("1" "$a[\"b\"]") 
  test_uut("2" "$a[c][d]")
  test_uut("2" "$[a][c][d]")
  test_uut("8;9;10" "$a.i")

return()



  ## interpret call tests
  define_test_function2(test_uut eval_expr2 interpret_call "")

  test_uut("${exception}")  # no token
  test_uut("${exception}" "")  # empty token
  test_uut("${exception}" "abc")  # no paren -> no call 
  test_uut("${exception}" "()")  # no lhs rvalue
  test_uut("${exception}" "()()") ## illegal lhs rvalue  
  function(my_func)
    arguments_encoded_list(0 ${ARGC})
    ans(result)
    list(INSERT result 0 my_func)
    return_ref(result)
  endfunction()

  string_codes()

  ## static functions
  test_uut("my_func" "my_func()")
  test_uut("my_func;1" "my_func(1)")
  test_uut("my_func;1;2" "my_func(1,2)")
  test_uut("my_func;1;2;3" "my_func(1,2,3)")

  test_uut("my_func;1;2${semicolon_code}3;4" "my_func(1,[2,3],4)") 
  test_uut("my_func;my_func${semicolon_code}my_func" "my_func(my_func(my_func()))") 

  ## elipsis
  test_uut("my_func;1;2;3" "my_func(1,[ 2 , 3]...)")

  ## dynamic function

  set(thefunc my_func)
  test_uut("my_func" "$thefunc()")
  test_uut("my_func;1" "$thefunc(1)")
  test_uut("my_func;1${semicolon_code}2;3${semicolon_code}4" "$thefunc([1,2],[3,4])")

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





  ## interpret assign

  define_test_function2(test_uut eval_expr2 interpret_assign "")
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







endfunction()