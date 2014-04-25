 # curry a function
  # let funcA(a b c d) -> return("${a}${b}${c}${d}")
  # and curry(funcA(/2 33 /1 44) as funcB)
  # funcB(22 55) -> 55332244   
  function(curry func)
    cmake_parse_arguments("" "" "as" "" ${ARGN})
    if(NOT _as)
      new_function(_as)
    endif()

    set(args ${_UNPARSED_ARGUMENTS})
    # remove parentheses
    list_pop_front( args)
    ans(paren_open)
    list_pop_back( args)
    ans(paren_close)

    set(arguments_string)
    set(call_string)
    
    set(bound_args)
    list(LENGTH args len)

    
    set(indices)
    foreach(arg ${args})
      if("${arg}" MATCHES "^/[0-9]+$")
        string(SUBSTRING "${arg}" 1 -1 arg)
        list(APPEND indices "${arg}")
        set(arg_name "__arg_${arg}")
        set(call_string "${call_string} \"\${__arg_${arg}}\"")  
      else()
        set(call_string "${call_string} \"${arg}\"")  
      endif()

    endforeach()

    list(LENGTH indices len)
    if("${len}" GREATER 1)
      list(SORT indices)
    endif()

    foreach(arg ${indices})
      set(arguments_string "${arguments_string} __arg_${arg}")
    endforeach()
   # message("leftovers: ${leftovers}")

    # if func is not a command import it
    if(NOT COMMAND "${func}")
      new_function(original_func)
      import_function("${func}" as ${original_func} REDEFINE)
    else()
      set(original_func "${func}")
    endif()

    set(evaluate
"function(${_as} ${arguments_string})${bound_args}
  ${original_func}(${call_string} \${ARGN})
  return_ans()
endfunction()")
  # message("${evaluate}")
    eval("${evaluate}")
    return_ref(_as)
  endfunction()