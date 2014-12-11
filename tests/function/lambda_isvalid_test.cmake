function(test)
  lambda_isvalid("(arg1 arg2)->math(EXPR sum '$arg1+$arg2');return($sum)")
  ans(res)
  assert(res)

  lambda_isvalid("()->")
  ans(res)
  assert(res)

  lambda_isvalid("")
  ans(res)
  assert(NOT res)
endfunction()