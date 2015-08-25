function(call2 callable)
  callable("${callable}")
  ans(callable)
  callable_call("${callable}")
  return_ans()
endfunction()

## faster version
function(call2 callable)
  callable_function("${callable}")
  set(current_function "${__ans}")
  eval("${__ans}(${ARGN})")
  set(__ans ${__ans} PARENT_SCOPE)
endfunction()