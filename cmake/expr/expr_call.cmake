
  function(expr_call str)    
    string(REPLACE ";" "†" str "${str}")

    string_nested_split("${str}" "\(" "\)")
    ans(parts)
#message("parts ${parts}")
    foreach(part ${parts})
      set(last_part "${part}")
     # message("${part}")
    endforeach()
    list_get(parts -2)
    ans(caller)
 #   message("caller ${caller}")
    string_slice("${caller}" 1 -2)

    ans(arguments)
    string(REPLACE "†" ";" arguments "${arguments}")
    set(evaluated_arguments)
    foreach(argument ${arguments})
      expr("${argument}")
      ans(evaluated_argument)
      set(evaluated_arguments "${evaluated_arguments}†${evaluated_argument}‡")
      
    endforeach()

    string_remove_ending("${str}" "${caller}")
    ans(path)
   # message("path ${path}")
    expr("${path}")
    ans(evaluated_path)
    
    string(REPLACE "‡†" "\" \"" evaluated_arguments "${evaluated_arguments}")
    string(REPLACE "‡" "\"" evaluated_arguments "${evaluated_arguments}")
    string(REPLACE "†" "\"" evaluated_arguments "${evaluated_arguments}")
    #message("evaled path ${evaluated_path}")
   # message("args ${arguments} -> ${evaluated_arguments}")

    set(call_statement "${evaluated_path}(${evaluated_arguments})")
   # message("${call_statement}")

    eval("${call_statement}")
    return_ans()
  endfunction()