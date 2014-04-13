function(test)

  lambda_parse("(test)->return('{test.lol} {test.lol2}')")
  ans(res)
  message("${res}")
  import_function("${res}" as mylambda REDEFINE)
  nav(test.lol abc)
  nav(test.lol2 def)
  mylambda("${test}")
  ans(res)
  assert("${res}" STREQUAL "abc def")


  lambda_parse("(arg1 arg2)->math(EXPR sum '$arg1+$arg2');return($sum)")
  ans(res)
  assert("${res}" STREQUAL "function(lambda_func arg1 arg2)\nset(__ans)\nmath(EXPR sum \"\${arg1}+\${arg2}\")\nreturn(\${sum})\nreturn_ans()\nendfunction()")
  
  endfunction()