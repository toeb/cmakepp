  ## (${ARGC}) => 
  ## 
  macro(arguments_encoded_list __arg_count)
    set(__arg_res)   
    if(${__arg_count} GREATER 0)
      math(EXPR __last_arg_index "${__arg_count} - 1")
      foreach(i RANGE 0 ${__last_arg_index} )        
        string_encode_list("${ARGV${i}}")
        list(APPEND __arg_res "${__ans}")
      endforeach()
      set(__ans "${__arg_res}")
    else()
      set(__ans)
    endif()
  endmacro()


    ## (${ARGC}) => 
  ## 
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