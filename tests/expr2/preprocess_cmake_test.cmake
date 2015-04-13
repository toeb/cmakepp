function(test)



  function(you)
    return("lol!${ARGN}")
  endfunction()




  cmakepp_eval("message($[you(you()) :: string_length()])")




endfunction()