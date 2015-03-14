function(test)




 function(linked_list)
  map_new()
  ans(head)
  map_set_special(${head} tail)
  return_ref(heads)
  foreach(arg ${ARGN})
    linked_list_append(${head} ${arg})
  endforeach()
 endfunction()

 function(linked_list_append list)
  map_get_special(${list} tail)
  ans(tail)
 endfunction()



  function(test_cmake_parse_identity str)
    timer_start(cmake_parse_string)
    cmake_parse_string("${str}" --extended)
    ans(root)
    #json_print(${root})
    timer_elapsed(cmake_parse_string)
    ans(parse_time)

    map_tryget(${root} children)
    ans(children)
    list(LENGTH children length)

    timer_start(cmake_parse_string)
    cmake_unparse("${root}")
    ans(res)
    timer_elapsed(cmake_parse_string)
    ans(unparse_time)
    message("took ${parse_time} ms to parse and ${unparse_time} ms to unparse ${length} tokens")
    assert("${res}" EQUALS "${str}")
  endfunction()

  function(test_cmake_parse str)
    cmake_parse_string("${str}" --extended)
    return_ans()
  endfunction()
  define_test_function(test_uut test_cmake_parse str)
  test_uut("{next:{value:'(', type:'nesting',next:{type:'nesting_end'}}}" "()")
  test_uut("{next:{value:'(', type:'nesting'}}" "(())")
  test_uut("{next:{value:'#[[asd]]',type:'bracket_comment'}}" "#[[asd]]")
  test_uut("{next:''}" "")
  test_uut("{next:{value:'asd', type:'command_invocation'}}" "asd()")
  test_uut("{next:{value:'asd', type:'command_invocation'}}" "asd ()")
  test_uut("{next:{value:'asd', type:'unquoted_argument'}}" "asd")
  test_uut("{next:{value:'asd', type:'unquoted_argument'}}" "asd ")
  test_uut("{next:{type:'quoted_argument',literal_value:'asd'}}" "\"asd\"")
  test_uut("{next:{type:'white_space',value:' '}}" " ")
  test_uut("{next:{type:'line_comment',value:'#', literal_value:''}}" "#")
  test_uut("{next:{type:'line_comment',value:'# hello ', literal_value:' hello '}}" "# hello \nbsd")
  
  return()
  #test_uut("{next:{value:'\"asd\"',literal_value:'asd', type:'quoted_argument'}}" "\"asd\"")
  test_cmake_parse_identity("#asdasd")
  test_cmake_parse_identity(";")
  test_cmake_parse_identity("asd;bsd")
 # test_cmake_parse_identity("asd\\ bsd")

  test_cmake_parse_identity("\"asd;bsd\"")
  test_cmake_parse_identity("asd")
  test_cmake_parse_identity("asd \"bsd\"")
  test_cmake_parse_identity("asd \"bsd\" (dadda)")


  test_cmake_parse_identity("set(asd bsd)")
  test_cmake_parse_identity("")
  test_cmake_parse_identity("set(asd bsd)")
  test_cmake_parse_identity("if(asd AND (BSD STREQUAL sd))\nset(asd ansdnasd)\nendif()")
  test_cmake_parse_identity("set(asd (asd (kdkd) asd) bsd)")
  test_cmake_parse_identity("set(\"asd\")")
  test_cmake_parse_identity("set(\"asd\" )")
  test_cmake_parse_identity("set(\"asd\" ) ")
  test_cmake_parse_identity(" set( \"as d\" ) ")
  test_cmake_parse_identity(" set( \"as d\" ) ")
  test_cmake_parse_identity(" set( 
    \"as
   d\"
   ) 
    ")

set(input 
"
set(source1
  dir1/file1.cmake
  dir1/file2.cmake
  dir1/file3.cmake
  dir1/file4.cmake
  dir1/file5.cmake
  dir1/file6.cmake
  dir1/file7.cmake
  # comment
  dir1/file8.cmake
  dir1/file9.cmake
  dir1/file10.cmake
  dir1/file11.cmake
  dir1/file12.cmake
  # comment 
  dir1/file13.cmake
  dir1/file14.cmake
  )

")


function(cmake_token value)
  ref_isvalid("${value}")
  ans(is_ref)
  if(is_ref)
    return_ref(value)
  endif()
  map_new()
  ans(token)
  map_set(${token} value ${value})
  return_ref(token)
endfunction()


function(cmake_insert_token_after previous token)
  cmake_token("${token}")
  ans(token)
  cmake_token(" ")
  ans(space1)
  cmake_token(" ")
  ans(space2)

  map_tryget(${previous} next)
  ans(next)
  
  map_set(${previous} next ${space1})
  map_set(${space1} next ${token})
  map_set(${token} next ${space2})
  map_set(${space2} next ${next})

endfunction()

cmake_parse_string("(asd)")
ans(res)
json_print(${res})



timer_start(t1)
cmake_parse_string("${input}" --extended)
ans(root)

timer_print_elapsed(t1)

assign(begin = root.command_invocations[0].next.next)
assign(end = root.command_invocations[0].next.end)


cmake_insert_token_after(${begin} "hello")


cmake_unparse("${root}")
ans(res)
_message("${res}")

#  fread("${cmakepp_base_dir}/cmake/collections/list_combinations.cmake")
#  ans(data)
 # test_cmake_parse_identity("${data}")


endfunction()