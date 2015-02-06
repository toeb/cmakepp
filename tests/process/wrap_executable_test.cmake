function(test)

  fwrite("myscript.cmake" "
    set(asd 0)

     while(asd LESS 100) 
      message(STATUS waht) 
      math(EXPR asd \"\${asd}+1\")
     endwhile()
     ")
  ans(path)
  wrap_executable(cmake_script_test "${CMAKE_COMMAND}" -P "${path}")


  cmake_script_test(--async-wait --result)
  ans(res)
  assertf({res.pid} MATCHES "[1-9][0-9]*")


  #set(OOCMAKE_DEBUG_EXECUTE true)
  
  assert(NOT COMMAND test_exectutable_wrapper)
  wrap_executable(test_exectutable_wrapper ${CMAKE_COMMAND})  

  ## assert that a function was created as specified
  assert(COMMAND test_exectutable_wrapper)


  fwrite("myscript.cmake" "message(hello)")
  fwrite("myerrorscript.cmake" "message(FATAL_ERROR byebye)")

  ## assert that --return-code  returns the correct return code 
  ## and working directory is correct
  test_exectutable_wrapper(-P myscript.cmake --return-code)
  ans(res)

  assert("${res}" EQUAL "0")

  ## assert that --return-code returns a non 0 return code whne execution reports error
  test_exectutable_wrapper(-P myerrorscript.cmake --return-code)
  ans(res)
  assert(NOT "${res}" EQUAL "0")


  ## assert that --result returns an object containing correct return code
  test_exectutable_wrapper(-P myscript.cmake --result)
  ans(res)
  assert(DEREF "{res.result}" STREQUAL "0") # return code should be error free
  assert(DEREF "{res.output}" MATCHES "hello") # stdout should contain only hello (possibly a line break)
  assert(DEREF "{res.timeout}" STREQUAL "-1") # timeout default value should be -1 (no timeout)

  test_exectutable_wrapper(-P myerrorscript.cmake --result)
  ans(res)
  assert(DEREF NOT "{res.result}" EQUAL "0")
  assert(DEREF "{res.output}" MATCHES "byebye") # stdout should contain only hello (possibly a line break)  
  assert(DEREF "{res.timeout}" STREQUAL "-1") # timeout default value should be -1 (no timeout)


  ## assert that no flag returns correct application output
  test_exectutable_wrapper(-P myscript.cmake)
  ans(res)
  assert("${res}" MATCHES "hello")


endfunction()