
  function(lambda_import lambda_expression function_name)
    lambda_parse("${lambda_expression}")
    ans(lambda_func)
    import_function("${lambda_func}" as ${function_name} REDEFINE)
    return()
  endfunction() 