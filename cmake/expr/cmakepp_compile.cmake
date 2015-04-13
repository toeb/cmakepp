
  function(cmakepp_compile content)
    cmake_token_range(" ${content}")##prepend whitespace (because of replace edgecase)
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
      map_tryget("${invocation}" invocation_token)
      ans(invocation_token)

      cmake_token_range_filter("${args_begin};${args_end}" NOT type MATCHES "(comment)")
      ans(argument_tokens)


      set(invocation_string)
      foreach(token ${argument_tokens})
        map_tryget("${token}" value)
        ans(value)
        set(invocation_string "${invocation_string}${value}")
      endforeach()
      encoded_list("${invocation_string}")
      ans(invocation_string)



      string(REGEX MATCHALL "${regex}"  tokens "${invocation_string}")
      set(current_code)
      set(compiled_code)
      set(new_invocation_string)
      set(is_expresion 0)
      set(depth 0)
      while(true)
        list(LENGTH tokens token_count)
        if(NOT token_count)
          break()
        endif()

        list(GET tokens 0 token)
        list(REMOVE_AT tokens 0)

        if("${token}_" STREQUAL "${bracket_open_code}_")
          math(EXPR depth "${depth} + 1")
          if("${last_token}_" STREQUAL "$_")
            set(is_expresion ${depth})
          else()
            set(new_invocation_string "${new_invocation_string}${token}")
          endif()
        elseif("${token}_" STREQUAL "${bracket_close_code}_")
          if(is_expresion AND "${depth}" EQUAL "${is_expresion}" )
            next_id()
            ans(ref)

            encoded_list_decode("${current_code}")
            ans(current_code)
            eval("expr_parse(interpret_expression \"\" ${current_code})")
            ans(ast)
            ast_compile("${ast}")
            ans(current_compiled_code)
            map_tryget("${ast}" value)
            ans(value)

            set(argument_value "\${${ref}}")
            set(compiled_code "${compiled_code}${current_compiled_code}set(${ref} ${value})\n")
            set(new_invocation_string "${new_invocation_string}${argument_value}")
              

            set(is_expresion 0)
            set(current_code)
          endif()
          math(EXPR depth "${depth} - 1")
        elseif("${token}_" STREQUAL "$_")
        elseif(depth)
          set(current_code "${current_code}${token}")
         else()
           set(new_invocation_string "${new_invocation_string}${token}")
         endif()
         set(last_token "${token}")

       endwhile()
       cmake_token_range_insert("${invocation_token}" "${compiled_code}")
       cmake_token_range_replace("${args_begin};${args_end}" "${new_invocation_string}")
    endforeach()


    cmake_token_range_serialize("${range}")
    ans(result)
    return_ref(result)
  endfunction()
