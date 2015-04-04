


  macro(arguments_extract_typed_values __start_arg_index __end_arg_index)
    set(__arg_res)   
    if(${__end_arg_index} GREATER ${__start_arg_index})

      math(EXPR __last_arg_index "${__end_arg_index} - 1")
      foreach(i RANGE ${__start_arg_index} ${__last_arg_index} )        
        encoded_list("${ARGV${i}}")
        list(APPEND __arg_res "${__ans}")
        #message("argv: '${ARGV${i}}' -> '${__ans}'")
      endforeach()
    endif()
    list_extract_typed_values(__arg_res ${ARGN})
  endmacro()