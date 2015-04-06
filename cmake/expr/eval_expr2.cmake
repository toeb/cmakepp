

function(eval_expr2 type arguments)
  list_extract_flag(arguments --print-code)
  ans(print_code)
string(MD5 __eval_expr_2_cache_key "_expr_${type}${arguments}${ARGN}" )
  if(NOT COMMAND "__expr2_${__eval_expr_2_cache_key}")
    arguments_expression("${type}" "${arguments}" 2 ${ARGC})
    rethrow()
    ans(context)
    map_tryget("${context}" result)
    ans(result)
    map_tryget("${result}" code)
    ans(code)
    map_tryget("${result}" argument)
    ans(argument)
    set(code "macro(__expr2_${__eval_expr_2_cache_key})\n${code}set(__ans ${argument} PARENT_SCOPE)\nendmacro()\n__expr2_${__eval_expr_2_cache_key}()")
    #_message("creating ${code}")
   
    if(print_code)
      _message("${code}")
    endif()


    eval_ref(code)
   else()
    set(code "__expr2_${__eval_expr_2_cache_key}()")
    eval_ref(code)
   endif()
endfunction()

