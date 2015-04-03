## 
##
## returns an encoded list for the specified arguments passed to
## current function invocation.
## 
## you can only use this inside of a cmake function and not inside a macro
macro(arguments_encoded_list2 __arg_begin __arg_end)
  set(__arg_res)   
  if(${__arg_end} GREATER ${__arg_begin})
    math(EXPR __last_arg_index "${__arg_end} - 1")
    foreach(i RANGE ${__arg_begin} ${__last_arg_index} )        
      encoded_list("${ARGV${i}}")
      list(APPEND __arg_res "${__ans}")
    endforeach()
    set(__ans "${__arg_res}")
  else()
    set(__ans)
  endif()
endmacro()