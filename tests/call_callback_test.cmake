function(test)

  mkdir("${test_dir}")
  cd("${test_dir}")

  # executes the specified callback which can be a file containing a function
# or a valid cmake function (anything callable (lambdas also)) 
# returns the result of call or throws an error
# varargs are passed on to callback function
function(call_callback callback)
  if(NOT COMMAND "${callback}")
     # rcall(cutilRun = ip.glob(${cutilRun}))
    
    if(NOT EXISTS "${callback}")
      message(FATAL_ERROR "callback '${callback}' does not exist")
    endif()
  endif()
  call(callback(${ARGN}))
  return_ans()
endfunction()

# calls a map callback.  uses the navigation expression to get the value for the callback
# if it does not exist "${defualt}" is called. default may be empty
# result of callback are returned
function(call_map_callback navigationExpression default)
  nav(callback = "${navigationExpression}")
  if(NOT callback)
    if("${default}_" STREQUAL "_")
      return()
    else()
      set(callback "${default}")
    endif()
  endif()
  call_callback("${callback}" ${ARGN})
  return_ans()
endfunction()



endfunction()