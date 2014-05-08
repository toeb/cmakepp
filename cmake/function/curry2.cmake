# laternative to curry (just one string argument)
  function(curry2 str)
    string(REPLACE " "  ";" str "${str}")
    string(REPLACE ")"  ";);" str "${str}")
    string(REPLACE "("  ";(;" str "${str}")
    #string(REPLACE "\"" "\\\"" str "${str}")
    
    #message("curry2... '${str}'")
    #string(REPLACE "" "" str "${str}")

    curry(${str} ${ARGN})
    return_ans()
  endfunction()