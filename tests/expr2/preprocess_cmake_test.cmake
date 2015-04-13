function(test)


  function(testf)
    ## enables expressions in current scope (scope being a file or a function)
    cmakepp_enable_expressions("${CMAKE_CURRENT_LIST_LINE}")
    message("so this is a test to look if it works $[test::string_length()]")
    return("$[test::string_length()]")
  endfunction()

  message("so this is a test to look if it works $[test::string_length()]")

  testf()
  ans(res)
  assert("${res}" EQUAL 4)


endfunction()



        # if(is_expresion AND "${depth}" EQUAL "${is_expresion}" )
        #   next_id()
        #   ans(ref)

        #   encoded_list_decode("${current_code}")
        #   ans(current_code)
        #   eval("expr_parse(interpret_expression \"\" ${current_code})")
        #   ans(ast)
        #   ast_compile("${ast}")
        #   ans(current_compiled_code)
        #   map_tryget("${ast}" value)
        #   ans(value)

        #   set(argument_value "\${${ref}}")
        #   set(compiled_code "${compiled_code}${current_compiled_code}set(${ref} ${value})\n")
        #   set(new_invocation_string "${new_invocation_string}${argument_value}")
            

        #   set(is_expresion 0)
        #   set(current_code)
        # else()
        #   set(new_invocation_string "${new_invocation_string}${token}")
        # endif()