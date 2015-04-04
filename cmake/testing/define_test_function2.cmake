
  ## defines a test function
  ## improved version.  use this 
  function(define_test_function2 function_name uut)
    arguments_cmake_string(2 ${ARGC})
    ans(predefined_args)

    ## store predefined_args in a ref which is restored 
    ## in function definition
    ## this is necessary because else the args would have to be escaped
    address_new()
    ans(predefined_address)
    address_set(${predefined_address} "${predefined_args}")


    ## define the test function 
    ## which executes the uut and compares
    ## it structurally to the expected value
    define_function("${function_name}" (expected)
      arguments_cmake_string(1 \${ARGC})
      ans(arguments)

      address_get(${predefined_address})
      ans(predefined_args)

      set(__ans)
      eval("${uut}(\${predefined_args} \${arguments})")
      ans(result)

      data("\${expected}")
      ans(expected)

      map_match("\${result}" "\${expected}" )
      ans(res)
      if(NOT res)
        echo_append("actual: ")
        json_print(\${result})
        echo_append("expected: ")
        json_print(\${expected})  
      endif()
      assert(res MESSAGE "values do not match")
    )
    return()
  endfunction()
