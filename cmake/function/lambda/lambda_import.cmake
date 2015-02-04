function(lambda_import lambda_expression function_name)
  lambda_parse("${lambda_expression}")
  ans(lambda_func)
  function_import("${lambda_func}" as ${function_name} REDEFINE)
  return_ans()
endfunction() 

