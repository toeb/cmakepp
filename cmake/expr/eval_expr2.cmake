

function(eval_expr2 type arguments)
  set(arguments ${arguments})
  list_extract_flag(arguments --print-code)
  ans(print_code)
  list_extract_flag(arguments --ast)
  ans(return_ast)
  string(MD5 __eval_expr_2_cache_key "_expr_${type}${arguments}${ARGN}" )
  if(NOT COMMAND "__expr2_${__eval_expr_2_cache_key}")
    arguments_expression("${type}" "${arguments}" 2 ${ARGC})
    rethrow()
    ans(context)
    map_tryget("${context}" result)
    ans(result)

    ast_compile("${result}")
    ans(code)

    address_set("${__eval_expr_2_cache_key}" ${result})

    map_tryget("${result}" value)
    ans(value)
    set(code "macro(__expr2_${__eval_expr_2_cache_key})\n${code}set(__ans ${value} PARENT_SCOPE)\nendmacro()\n__expr2_${__eval_expr_2_cache_key}()")
    #_message("creating ${code}")

   
    if(print_code)
      _message("${code2}")
      _message("#### args: ${value} ######")
    endif()

    if(return_ast)
      return(${result})
    endif()


    eval_ref(code)
   

   else()
    if(return_ast)
      address_get("${__eval_expr_2_cache_key}")
      ans(ast)
      return_ref(ast)
    endif()
    set(code "__expr2_${__eval_expr_2_cache_key}()")
    eval_ref(code)
   endif()
endfunction()

