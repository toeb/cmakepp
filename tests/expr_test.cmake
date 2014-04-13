function(test)

  function(expr_assignment_isvalid str)
    set(regex_single_quote_string "'[^']*'")
    set(regex_double_quote_string "\"[^\"]*\"")
    set(regex_string "((${regex_single_quote_string})|(${regex_double_quote_string}))")
    
    string(REGEX REPLACE "${regex_string}|[^=]" "" res "${str}")
    if(res)
      return(true)
    endif()
    return(false)
  endfunction()

  function(list_set __list_set_lst index value)
    if("${index}" EQUAL -1)
      #insert element at end
      list(APPEND ${__list_set_lst} ${value})
      set(${__list_set_lst} ${${__list_set_lst}} PARENT_SCOPE)
      return(true)
    endif()
    list_normalize_index(${__list_set_lst} "${index}")
    ans(index)
    if(index LESS 0)
      return(false)
    endif()
    list_replace_at(${__list_set_lst} "${index}" "${value}")

    set(${__list_set_lst} ${${__list_set_lst}} PARENT_SCOPE)
    return(true)
  endfunction()


  list_set(testlist -1 a)
  list_set(testlist -1 b)
  list_set(testlist -1 c)
  list_set(testlist -2 d)
  message("${testlist}")
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

  function(list_empty __list_empty_lst)
    list(LENGTH  ${__list_empty_lst} len)
    if("${len}" EQUAL 0)
      return(true)
    endif()
    return(false)
  endfunction()
#‡†
  function(expr_assign_lvalue lvalue rvalue scope)
    message("assigning ${lvalue} = ${rvalue}")
   # string_char_at(trash 0 "${lvalue}" )
   # ans(first_char)
   # if("${first_char}" STREQUAL "*")
   #   #message("dereffing")
   #   string(SUBSTRING "${lvalue}" 1 -1 ref_expr)
   #   expr("${ref_expr}")
   #   ans(ref)
   #   if(NOT ref)
   #     message(FATAL_ERROR "${ref_expr} does not evaluate to a ref")
   #   endif()
   #  # message("ref is ${ref}")
   #   ref_isvalid(${ref} trash)
   #   ans(isref)
   #   if(isref)
   #   #message("assigning ref ${rvalue}")
   #     ref_set(${ref} "${rvalue}")
   #   endif()
   #   return()
   # endif()
    set(regex_identifier "[a-zA-Z0-9-_]+")

    string(REPLACE ";" "†" lvalue "${lvalue}")
    

    if(NOT "${first_char}"  STREQUAL "[")
      set(lvalue ".${lvalue}")
    endif()


    string_nested_split("${lvalue}" "[" "]")
    ans(splits)
    message("splits ${splits}")
    set(lvalue)


    foreach(split ${splits})
      if("${split}" MATCHES "^\\[.+\\]$")
        string_slice("${split}" 1 -2)
        ans(inner_split)
        expr("${inner_split}")
        ans(split)
        set(split "[${split}]")
      endif()
      list(APPEND lvalue "${split}")
    endforeach()
    string(REPLACE ";" "" lvalue "${lvalue}")
    string(REPLACE "†" ";" lvalue "${lvalue}")
    string(REPLACE "." ";" lvalue "${lvalue}")
    string(REPLACE "[" ";" lvalue "${lvalue}")
    string(REPLACE "]" "" lvalue "${lvalue}") 


   # string(REGEX REPLACE "")
    message("lvalue transformed: ${lvalue}")

    set(current_scope ${scope})
    set(last_scope)
    set(path ${lvalue})
    set(current_index)
    set(last_index)
    while(true)
      set(next_scope)
      set(last_index ${current_index})
      list_pop_front(current_index path )  
      list_empty(path)
      ans(is_done)

      
      map_isvalid(${current_scope} trash)
      ans(is_map)

      ref_isvalid(${current_scope} trash)
      ans(is_ref)
      

      expr_integer_isvalid("${current_index}")
      ans(is_int_index)

      message("current index: ${current_index}")
      message("rest:${path}")
      message("int index:${is_int_index}")
      message("is_done ${is_done}")
      message("is_map ${is_map}")
      message("is_ref ${is_ref}\n")


      
      if(is_map)
        if(is_int_index)
          map_keys(${current_scope} keys)
          list_get(keys "${current_index}")
          ans(current_index)
        endif()
        if(NOT current_index)
          # invalid key
          message(FATAL_ERROR "invalid key '${current_index}'")
          return()
        endif()
        # index now is a string index in all cases

        if(is_done)
          map_set(${current_scope} "${current_index}" "${rvalue}")
          return_ref(rvalue)
          # finished setting value
        endif()
        # navigate
        map_tryget(${current_scope} next_scope "${current_index}")
        if(NOT next_scope)
          map_create(next_scope)
          map_set(${current_scope} "${current_index}" ${next_scope})
        endif()

        # next_scope exists

      elseif(is_ref)
        if(is_done)
          ref_set(${current_scope} ${rvalue})
          return_ref(rvalue)
          # finished setting value
        endif()

        if(NOT is_int_index)
          message(FATAL_ERROR "can only set string indices on maps")
          return()
        endif()

        message(FATAL_ERROR "not iplemented for ref currently") 


      else()
        message("just a var")
        if(is_done)
          if(NOT is_int_index)
              message(FATAL_ERROR "cannot set string index for a cmake list")
          endif()
          map_get(${last_scope} last_value ${last_index})
          list_set(last_value ${current_index} "${rvalue}")
          ans(success)
          if(NOT success)
            message(FATAL_ERROR "cannot set ${current_index} because it is invalid for list")
          endif()
          map_set(${last_scope} ${last_index} "${last_value}")
        endif()
      endif()


      set(last_scope ${current_scope})
      set(current_scope ${next_scope})

      if(is_done)
        break()
      endif()
    endwhile()

    return()
  endfunction()
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



  function(expr_assignment str scope)
    set(regex_single_quote_string "'[^']*'")
    set(regex_double_quote_string "\"[^\"]*\"")
    set(regex_string "((${regex_single_quote_string})|(${regex_double_quote_string}))")
    
    string(REGEX MATCHALL "(${regex_string}|[^=]+|=)" matches "${str}")

    set(lvalues)
    set(rvalues)

    foreach(match ${matches})     
      string(STRIP "${match}" match) 
      if("${match}" STREQUAL "=" )
        list(APPEND lvalues ${rvalues})
        set(rvalues)
      endif()
      list(APPEND rvalues "${match}")
    endforeach()
    
    list(REMOVE_ITEM lvalues =)
    list(REMOVE_ITEM rvalues =)

    expr("${rvalues}")

    ans(rvalue)

    message("lvalues ${lvalues}")
    message("rvalues ${rvalues} => ${rvalue}")


    foreach(lvalue ${lvalues})
      expr_assign_lvalue("${lvalue}" "${rvalue}" ${scope})
    endforeach()
    
  endfunction()
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



return()



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