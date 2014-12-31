function(test)

  function(test_uri uri expected )
    set(args ${ARGN})
    list_extract_flag(args --print)
    ans(print)


    uri_parse("${uri}" ${args})
    ans(uut)
    
    if(print)
      json_print(${uut})
    endif()

    obj("${expected}")
    ans(expected)

    map_iterator(${expected})
    ans(iter)

    while(true)
      map_iterator_break(iter)
      map_tryget(${uut} ${iter.key})
      ans(value)
      assert(EQUALS ${iter.value} ${value})
    endwhile()
  endfunction()


  ## test schemes

  test_uri("asd+basd:" "{scheme:'asd+basd',schemes:['asd','basd'] }")




  function(uri_params_serialize )
    function(uri_params_serialize_value)

      set(path ${path})
      list_pop_front(path)
      ans(first)


      set(res "${first}")
      foreach(part ${path})
        uri_encode("${part}")
        ans(part)
        set(res "${res}[${part}]")
      endforeach()

      uri_encode(${node})
      ans(node)
      set(res "${res}=${node}")
      map_append(${context} assignments ${res})
    endfunction()
   map()
    kv(value uri_params_serialize_value)
   end()
  ans(callbacks)
  function_import_table(${callbacks} uri_params_serialize_callback)

  # function definition
  function(uri_params_serialize obj )
    obj("${obj}")
    ans(obj)  
    map_new()
    ans(context)
    dfs_callback(uri_params_serialize_callback ${obj})
    map_tryget(${context} assignments)
    ans(assignments)
    string_combine("&" ${assignments})
    return_ans()  
  endfunction()
  #delegate
  uri_params_serialize(${ARGN})
  return_ans()
  endfunction()



  uri_params_serialize("{a:{b:{c:1}}}")
  ans(res)
  assert("${res}" STREQUAL "a[b][c]=1")


#   function(navigation_path)
#     return(${ARGN})
#   endfunction()

#   function(navigation_propref)
#     foreach(arg ${argn})

#     endforeach()
#   endfunction()

#   return()


#   ## map_path_set(first key key key value)
#   ## ensures that the path from ${first} to value exists and is set to the specified value 
#   ##
#   ## 
#   function(map_path_set first)
      



#   endfunction()

#   function(map_assignable_path first)

#     foreach(arg ${ARGN})
#     endforeach()


#   endfunction()

#   set(a)
#   map_assignable_path(a b c)
#   ans(res)
#   assert(${res} EQUALS a)

#   set(a)
#   map_assignable_path(a [0])
#   ans(res)
#   assert(${res} EQUALS a)

#   set(a 1)
#   map_assignable_path(a [0])
#   ans(res)
#   assert(${res} EQUALS a [0])


#   obj("{b:{c:1}}")
#   ans(a)
#   map_assignable_path(a b c)
#   ans(res)
#   assert(${res} EQUALS a b c)





#   set(a a b c)
#   map_assignable_path()

# return()





  # ref property? indexer
  function(lvalue)
    list(LENGTH ARGN len)
    if(${len} EQUAL 4)
      set(__ans ${ARGN} PARENT_SCOPE)
    endif()
    
    string(REGEX REPLACE "([a-zA-Z0-9_\\-]+).*" "\\1" ref "${ARGN}")
    string(REGEX REPLACE "[^\\[]*\\[(.*)\\]" "\\1" indexer "${ARGN}")
    if("${indexer}" STREQUAL "${ARGN}")
      set(indexer 0 *)
    else()
      string(REPLACE - ";" indexer "${indexer}")
      if("${indexer}_" STREQUAL "_")
        set(indexer -1 -1)
      else()
        list(GET indexer 0 low)
        list(REMOVE_AT indexer 0)

        if("${indexer}_" STREQUAL _)
          math(EXPR indexer "${low} + 1")
        elseif(NOT "${indexer}_" STREQUAL "*_")
          matH(EXPR indexer "${indexer} + 1")
        endif()          
        set(indexer "${low}" "${indexer}")
      endif()
    endif()
    string(REGEX REPLACE "[^\\.]+\\.([^\\[])+.*" "\\1" prop "${ARGN}")
    if("${prop}" STREQUAL "${ARGN}")
      set(prop "")
    endif()
    set(res "${ref};${indexer};${prop}")
    return_ref(res)
  endfunction()







  macro(lvalue_unpack __lvalue)
    lvalue(${${__lvalue}})
    ans(${__lvalue})
    list(GET ${__lvalue} 0 ${__lvalue}.ref)
    list(GET ${__lvalue} 1 2 ${__lvalue}.indexer)
    list(GET ${__lvalue} 3 ${__lvalue}.prop)
    if("${${__lvalue}.prop}_" STREQUAL "_" )
      set(${__lvalue}.has_prop false)
    else()
      set(${__lvalue}.has_prop true)
    endif()
    map_isvalid("${${${__lvalue}.ref}}")
    ans(${__lvalue}.is_map)
  endmacro()

  function(lvalue_get lvalue)
    lvalue_unpack(lvalue)
    message("hasprop ${lvalue.has_prop} ismap ${lvalue.is_map}")
    if(lvalue.is_map AND lvalue.has_prop)
      map_tryget(${${lvalue.ref}} ${lvalue.prop})
      ans(val)

    else()
      set(val ${${lvalue.ref}})
    endif()


    list_slice(val ${lvalue.indexer})
    ans(result)

    return_ref(result)




  endfunction()




  function(lvalue_set lvalue)
    lvalue_unpack(lvalue)
    if(lvalue.has_prop)
      if(NOT lvalue.is_map)
        ## cause an error here if path should not be created
        map_new()
        ans(${lvalue.ref})
      endif()
      map_tryget("${${lvalue.ref}}" "${lvalue.prop}")
      ans(val)
      list_replace_slice(val ${lvalue.indexer} ${ARGN})
      map_set("${${lvalue.ref}}" "${lvalue.prop}" ${val})
    else()
      list_replace_slice(${lvalue.ref} ${lvalue.indexer} ${ARGN})
    endif()
    set(${lvalue.ref} ${${lvalue.ref}} PARENT_SCOPE)
  endfunction()





  return()

  set(uut "prop")
  arg_unpack(uut)
  message("is_range '${uut.is_range}', is_property '${uut.is_property}', range '${uut.range}', '${uut.range.begin}:${uut.range.increment}:${uut.range.end}', property '${uut.property}'")

  return()
  set(asd "abc")
  arg_unpack(asd)
  assert(${asd.range.increment} EQUALS 1)
  assert(${asd.range.begin} EQUALS 0)
  assert(${asd.range.end} EQUALS *)

  assert(${asd.property} EQUALS abc)
  assert(${asd.is_range} EQUALS false)
  assert(${asd.is_property} EQUALS true)

  set(asd "[]")
  arg_unpack(asd)
  assert(${arg.range} EQUALS *:*)
  assert(${arg.property} ISNULL)
  assert(${arg.is_range} EQUALS true)
  assert(${arg.is_property} EQUALS false) 

  set(asd "[3]")
  arg_unpack(asd)
  assert(${arg.range} EQUALS 3 4)
  assert(${arg.property} ISNULL)
  assert(${arg.is_range} EQUALS true)
  assert(${arg.is_property} EQUALS false)


  set(asd [3-4])
  arg_unpack(asd)
  assert(${arg.range} EQUALS 3 5)
  assert(${arg.property} ISNULL)

  set(asd "[3-*]")
  arg_unpack(asd)
  assert(${arg.range} EQUALS 3 *)
  assert(${arg.property} ISNULL)

  return()

  function(path_create)
    map_new()
    ans(current_map)
    


    foreach(arg ${ARGN})
      arg_unpack("${arg}")

    endforeach()
    

    set(${first})

  endfunction()






  return()

  function(lvalue_path first)

    map_new()
    ans(root_map)
    map_set(${root_map} ${first} ${${first}})


    set(current_map ${root_map})
    set(current_prop ${first})
    set(current_indexer 0 *)

    set(args ${ARGN})
    list_pop_back(args)
    ans(value)

    foreach(arg ${args})
      set(indexer)
      set(property)
      set(val)
      if("${arg}" MATCHES "^\\[.*\\]$")
        string(REGEX REPLACE "\\[(.*)\\]" "\\1" indexer "${arg}")
      else()
        set(property "${arg}")
      endif()




    endforeach()

    map_set("${current_map}" "${current_prop}" "${value}")


    map_tryget(${root_map} ${first})
    ans(res)
    set(${first} ${res} PARENT_SCOPE)
    return()
  endfunction()


  set(a)
  lvalue_path(a b)
  assert(${a} EQUALS b)

  set(a)
  lvalue_path(a [] b)
  assert(${a} EQUALS b)




return()

  set(a)
  lvalue_set(a.b hi)
  assert(a)
  assertf({a.b} STREQUAL "hi")

  set(a)
  lvalue_set(a.b a b c d)
  assert(a)
  assertf({a.b} EQUALS a b c d)

  obj("{c:2}")
  ans(a)
  lvalue_set(a.b asdasd)
  assertf({a.c} EQUAL 2)
  assertf({a.b} STREQUAL asdasd)

  obj("{b:'asd'}")
  ans(a)
  lvalue_set(a.b kakaka)
  assertf({a.b} STREQUAL kakaka)


  obj("{b:'asd'}")
  ans(a)
  lvalue_set(a.b[] kakaka)
  assertf({a.b} EQUALS asd kakaka)

  obj("{b:[1,2,3,4]}")
  ans(a)
  lvalue_set(a.b[1-2] a b)
  assertf({a.b} EQUALS 1 a b 4)


  obj("{b:[1,2,3,4]}")
  ans(a)
  lvalue_set(a.b[1-*])
  assertf({a.b} EQUALS 1)

  set(a)
  lvalue_set(a hello)
  assert(${a} STREQUAL "hello")

  set(a)
  lvalue_set(a hello hello)
  assert(${a} EQUALS hello hello)

  set(a)
  lvalue_set(a[] hello)
  assert(${a} EQUALS hello)

  set(a byby)
  lvalue_set(a[] hello)
  assert(${a} EQUALS byby hello)


  set(a a b c)
  lvalue_set(a[1] gaga)
  assert(${a} EQUALS a gaga c)

  set(a a b c d)
  lvalue_set(a[1-2] 1 2 3 4)
  assert(${a} EQUALS a 1 2 3 4 d)

  set(a k b c d)
  lvalue_set(a[1-*])
  assert(${a} EQUALS k)



  return()



  set(a 2)
  lvalue_get(a)
  ans(res)
  assert(${res} EQUAL 2)


  set(a 2 3 4)
  lvalue_get(a)
  ans(res)
  assert(${res} EQUALS 2 3 4)


  set(a 2 3 4)
  lvalue_get(a[1])
  ans(res)
  assert(${res} EQUALS 3)


  set(a 2 3 4 5)
  lvalue_get(a[1-2])
  ans(res)
  assert(${res} EQUALS 3 4)



  obj("{b:3}")
  ans(a)
  lvalue_get(a.b)
  ans(res)
  assert(${res} EQUALS 3)


  obj("{b:[3,4,5]}")
  ans(a)
  lvalue_get(a.b[1])
  ans(res)
  assert(${res} EQUALS 4)

  obj("{b:[3,4,5]}")
  ans(a)
  lvalue_get(a.b)
  ans(res)
  assert(${res} EQUALS 3 4 5)





  return()


  lvalue(a)
  ans(res)
  assert(${res} EQUALS a 0 * "")

  lvalue(a[2])
  ans(res) 
  assert(${res} EQUALS a 2 3 "")

  lvalue(a.b)
  ans(res)
  assert(${res} EQUALS a 0 * b)

  lvalue(a.b[2])
  ans(res)
  assert(${res} EQUALS a 2 3 b)

  lvalue(a.b[2-3])
  ans(res)
  assert(${res} EQUALS a 2 4 b)

  lvalue(a.b[1-*])
  ans(res)
  assert(${res} EQUALS a 1 * b)


  return()


  function(lvalue_set lvalue)


  endfunction()
  function(lvalue_get)

  endfunction()

  lvalue("{a:{b:{c:1}}}")

return()


  obj("{d:1,c:2}")
  ans(a)
  json_print(${a})


  map_path_set(a d)

  return()
  map_path_set(a b c d e)
  map_path_set(a [] c)
  map_path_set(x y [2] d)

  message("${a}")
return()



  define_test_function(test_uut map_path_set)


  #test_uut("asd" thevar asd --print)
  #test_uut("{a:'b'}" thevar a b)
  #test_uut("1" thevar [] 1)







  return()

  function(map_path_append first)
    set(args ${ARGN})

    list_pop_back(args)
    ans(value)

    if(NOT args)
      set(${first} ${${first}} ${value} PARENT_SCOPE)
      return()
    endif()

    set(current ${${first}})

    if(NOT current)


    endif()


  endfunction()




  function(uri_params_deserialize query)
      
    string(REPLACE "&" "\;" query_assignments "${query}")
    string(ASCII 21 c)
    map_new()
    ans(query_data)
    foreach(query_assignment ${query_assignments})
      string(REPLACE "=" "\;"  value "${query_assignment}")
      list_pop_front(value)
      ans(key)
      
      string(REPLACE "[]" "[${c}]" path "${key}")
      string(REPLACE "[" "\;" path "${path}")
      string(REPLACE "]" "" path "${path}")

      message("parts: '${path}'")
      uri_decode("${path}")
      ans(path)
      uri_decode(${value})
      ans(value)

      map_path_set(query_data ${path} "${value}")

    endforeach()
    return_ref(query_data)
  endfunction()



  define_test_function(test_uut uri_params_deserialize)

  test_uut("{a:2}" "a=2")
  test_uut("{a:{b:2}}" "a[b]=2")
  test_uut("{a:[2,3]}" "a[]=2&a[]=3")
  test_uut("{a:[1,2,{c:3}]}" "a[]=1&a[]=2&a[2][c]=3")

return()
  ## test query

function(uri_parse_query uri)
  map_tryget(${uri} query)
  ans(query)

  string(REPLACE "&" "\;" query_assignments "${query}")

  map_new()
  ans(query_data)
  foreach(query_assignment ${query_assignments})
    string(REPLACE "=" "\;"  value "${query_assignment}")
    list_pop_front(value)
    ans(key)
    uri_decode(${value})
    ans(value)
    uri_decode(${key})
    ans(key)
    map_set(${query_data} "${key}" "${value}")
  endforeach()


  map_capture(${uri} query_assignments query_data)

endfunction()


  test_uri("?hello=asd" "{query:'hello=asd'}")
  test_uri("?hello=asd" "{query_assignments:'hello=asd'}")
  test_uri("?hello=asd&byby=bsd" "{query_assignments:['hello=asd','byby=bsd']}")
  test_uri("?hello=asd&byby=asd" "{}" --print)



return()


## normalized path

test_uri("../asd/../../bsd/csd/dsd/../../esd/./fsd" "{normalized_segments:['..','..','bsd', 'esd', 'fsd']}" )
# examples
#  test_uri("'scheme1+http://user:password@102.13.44.32:234/C:\\Progr%61m Files(x86)/dir number 1\\file.text.txt?asd=23#asd'" "{}")
#  test_uri("https://www.google.de/u/0/mail/?arg1=123&arg2=arg4#readmails some other data" "{}" --print)
#  test_uri("C:\\windows\\path" "{}" --print)

  ## test userinfo

  test_uri("test" "{user_info:null}")
  test_uri("//becker@localhost" "{user_info:'becker'}")
  test_uri("//becker:password@localhost" "{user_info:'becker:password'}")
  
  ## test dns fields

  test_uri("//becker.tobi:asdasd@192.168.0.1:2313/path/to/nirvana" "{password:'asdasd', user_name:'becker.tobi', ip:'192.168.0.1', port:'2313'}") 


  ## test authority
  test_uri("test" "{authority:null}")
  test_uri("//www.google.de" "{authority:'www.google.de'}")
  test_uri("http://www.google.de" "{authority:'www.google.de'}")


  
  # test net_path

  test_uri("test" "{net_path:null}")
  test_uri("C:\\test\\path" "{net_path:'/C:/test/path'}") # because file:// is prepended it is a net_path
  test_uri("/test" "{net_path:'/test'}") # because file:// is prepended it is a net_path
  test_uri("http://localhost" "{net_path:'localhost'}")
  test_uri("http://google.de/file.txt" "{net_path:'google.de/file.txt'}")
  test_uri("mailto:becker@google.de" "{net_path:null}")# no not path because no //
  test_uri("scheme:/de/fa" "{net_path:null}")# no not path because no //


  
  ## test normalization

  test_uri("test a b c" "{uri:'test',rest:' a b c'}")
  test_uri("'test a b c'" "{uri:'test%20a%20b%20c'}")
  test_uri("\"test a b c\"" "{uri:'test%20a%20b%20c'}")
  test_uri("<test a b c>" "{uri:'test%20a%20b%20c'}")
  test_uri("C:/test a b c" "{uri:'file:///C:/test',rest:' a b c'}")
  test_uri("C:\\test\\other a b c" "{uri:'file:///C:/test/other',rest:' a b c'}")
  test_uri("/dev/null a b c" "{uri:'file:///dev/null',rest:' a b c'}")
  test_uri("'C:/test a b c'" "{uri:'file:///C:/test%20a%20b%20c'}")
  test_uri("'C:\\test\\other a b c'" "{uri:'file:///C:/test/other%20a%20b%20c'}")
  test_uri("'/dev/null a b c'" "{uri:'file:///dev/null%20a%20b%20c'}")
  test_uri("//sometext" "{uri:'//sometext'}")

  ## test path

  test_uri("test a b c" "{path:'test'}")
  test_uri("'test a b c'" "{path:'test%20a%20b%20c'}")
  test_uri("C:\\test a b c" "{path:'/C:/test'}")
  test_uri("'C:\\test\\path b\\file.exe'" "{path:'/C:/test/path%20b/file.exe'}")
  test_uri("'a/b c/d'" "{path:'a/b%20c/d'}")
  test_uri("/a/b/c" "{path:'/a/b/c'}")
  test_uri("/a/b/c/" "{path:'/a/b/c/'}")
  test_uri("D:/" "{path:'/D:/'}")
  test_uri("\"C:/Program Files(x86)/Microsoft Visual Studio/Common7\"" "{path:'/C:/Program%20Files(x86)/Microsoft%20Visual%20Studio/Common7'}")
  test_uri("https://www.google.de/u/20/view.xmls?asd=32#showme" "{path:'/u/20/view.xmls'}")
  test_uri("somescheme:somepath/a/b/c" "{path:'somepath/a/b/c'}")

  ## test segments
  
  test_uri("test a b c" "{segments:'test'}")
  test_uri("'test a'" "{segments:'test a'}")
  test_uri("https://github.com/test2" "{segments:'test2'}")
  test_uri("https://github.com/test2/test3" "{segments:['test2','test3']}")
  test_uri("mailto:toeb@github.com" "{segments:'toeb@github.com'}")
  test_uri("'C:\\Program Files\\cmake\\bin\\cmake.exe'" "{segments: ['C:','Program Files', 'cmake', 'bin', 'cmake.exe']}")
  test_uri("C:\\" "{segments:'C:'}")
  test_uri("C:/" "{segments:'C:'}")
  test_uri("/" "{segments:null}")

  ## test lastsegment
  
  test_uri("test/a/b/c.txt" "{last_segment:'c.txt'}")
  test_uri("c.txt" "{last_segment:'c.txt'}")
  test_uri("/" "{last_segment:null}")


  ## test file
  test_uri("test.txt" "{file:'test.txt', file_name:'test', extension:'txt'}")
  test_uri("test" "{file:'test', file_name:'test', extension:null}")
  test_uri("test.txt.xml" "{file:'test.txt.xml' , file_name:'test.txt', extension:'xml'}")
  test_uri("/" "{file:null,file_name:null,extension:null}")

return()

endfunction()