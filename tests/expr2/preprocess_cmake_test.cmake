function(test)


  set(content "
    set(a \"a b vc $[hello()]mumumu $[hello()]\")
    ")


  function(preprocess_cmake content)
    cmake_token_range("${content}")
    ans(range)

    cmake_invocation_filter_token_range("${range}")
    ans(invocations)

    string_codes()
    set(regex "[\\$${bracket_open_code}${bracket_close_code}]|[^\\$${bracket_open_code}${bracket_close_code}]+")

    foreach(invocation ${invocations})
      map_tryget("${invocation}" arguments_begin_token)
      ans(args_begin)
      map_tryget("${invocation}" arguments_end_token)
      ans(args_end)

      cmake_token_range_filter("${args_begin};${args_end}" type MATCHES "(argument)|(nesting)")
      ans(argument_tokens)


      set(depth 0)
      foreach(argument_token ${argument_tokens})
        map_tryget("${argument_token}" value)
        ans(argument_value)
        encoded_list("${argument_value}")
        ans(argument_value)

        set(compiled_code)
        set(result_value)
        set(expr_code)
        string(REGEX MATCHALL "${regex}"  argument_value "${argument_value}")
        set(partial result)
        foreach(partial ${argument_value})
          if("${partial}_"  STREQUAL "${bracket_open_code}_")
            math(EXPR depth "${depth} + 1")
          elseif("${partial}_" STREQUAL "${bracket_close_code}_")
            math(EXPR depth "${depth} - 1")
            if(NOT depth)
              eval("expr_parse(interpret_expression \"\" ${expr_code})")
              ans(ast)
              map_tryget("${ast}" value)
              ans(value)
              ast_compile("${ast}")
              ans(code)
              next_id()
              ans(id)
              set(compiled_code "${compiled_code}## code for ${expr_code}\n${code}set(${id} ${value})\n")
              
              set(result_value "${result_value}\${${id}}")
              set(expr_code)
            endif()
          elseif("${partial}_" STREQUAL "$_" AND NOT depth)
          elseif(depth)
            set(expr_code "${expr_code}${partial}")
          else()
            set(result_value "${result_value}${partial}")
          endif()

        endforeach()
        map_tryget("${argument_token}" next)
        ans(end_of_argument)
        cmake_token_range_replace("${argument_token};${end_of_argument}" "${result_value}")
      endforeach()  

      map_tryget("${invocation}" invocation_token)
      ans(invocation_token)
      cmake_token_range_insert("${invocation_token}" "${compiled_code}")


    endforeach()

    cmake_token_range_serialize("${range}")
    return_ans()
  endfunction()

  preprocess_cmake("${content}")
  ans(res)
  message("${res}")
endfunction()