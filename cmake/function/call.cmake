
  # no output except through return values or referneces
  function(call)

    return_reset()
    # I used garbled variable names to keep from hiding parent scope varaibles
   # message("wooooaoaat? ${ARGN}")
    set(__function_call_args ${ARGN})

    list_pop_front( __function_call_args)
    ans(__function_call_func)
    list_pop_front( __function_call_args)
    ans(__function_call_paren_open)
    list_pop_back( __function_call_args)
    ans(__function_call_paren_close)
    
    if(NOT "_${__function_call_paren_open}" STREQUAL "_(")
      message(WARNING "expected opening parentheses for function '${ARGN}'")
    endif()
    if(NOT "_${__function_call_paren_close}" STREQUAL "_)")
      message(WARNING "expected closing parentheses '${ARGN}'")
    endif()
    #message("---${ARGN}===${__function_call_func}")
    if(COMMAND "${__function_call_func}")
   #   message("function")
      set(__function_call_args2)
      foreach(__function_call_args_arg ${__function_call_args})
        set(__function_call_args2 "${__function_call_args2} \"${__function_call_args_arg}\"")
      endforeach()
      eval("${__function_call_func}(${__function_call_args2})")
      return_ans(res)
     # message("function returned '${res}'")
      
    endif()

    if(DEFINED "${__function_call_func}")
    # message("defined ${__function_call_func}")
      call("${${__function_call_func}}"(${__function_call_args}))
      return_ans()
    endif()

    ref_isvalid("${__function_call_func}")
    ans(isref)
    if(isref)
  #    message("call for ${__function_call_func} ")
      obj_call("${__function_call_func}" ${__function_call_args})
      return_ans()
    endif()

    propref_isvalid("${__function_call_func}")
    ans(ispropref)
    if(ispropref)
      propref_get_key("${__function_call_func}")
      ans(key)
      propref_get_ref("${__function_call_func}")
      ans(ref)

      obj_callmember("${ref}" "${key}" ${__function_call_func})

    endif()



    lambda_isvalid("${__function_call_func}")      
    ans(is_lambda)
    if(is_lambda)
    #  message("lambda ${__function_call_func} args ${__function_call_args}")
      lambda_import("${__function_call_func}" __function_call_import)
      __function_call_import(${__function_call_args})
      return_ans()
    endif()


    if(DEFINED "${__function_call_func}")
      call("${__function_call_func}"(${__function_call_args}))
      return_ans()
    endif()


    is_function(is_func "${__function_call_func}")
    if(is_func)
   #   message("importing ${__function_call_func}(${__function_call_args})")
      function_import("${__function_call_func}" as __function_call_import REDEFINE)
      __function_call_import(${__function_call_args})
      return_ans()
    endif()

    if("${__function_call_func}" MATCHES "^[a-z0-9A-Z_-]+\\.[a-z0-9A-Z_-]+$")
      string_split_at_first(__left __right "${__function_call_func}" ".")
      ref_isvalid("${__left}")
      ans(__left_isref)
      if(__left_isref)
        obj_callmember("${__left}" "${__right}" ${__function_call_args})  
        return_ans()
      endif()
      ref_isvalid("${${__left}}")
      ans(__left_isrefref)
      if(__left_isrefref)
        obj_callmember("${${__left}}" "${__right}" ${__function_call_args})
        return_ans()
      endif()
    endif()

    nav(__function_call_import = "${__function_call_func}")
    if(__function_call_import)
     #message("nav ${__function_call_import} ${__function_call_func}")
         call("${__function_call_import}"(${__function_call_args}))
      return_ans()
    endif()

   # message("nothin")
   message(FATAL_ERROR "tried to call a non-function: ${__function_call_func}")
  endfunction()