function(test)




  function(environment_package_source)

  endfunction()

  function(package_source_environment_query uri)
    set(args ${ARGN})

    list_extract_flag(--package-handle)
    ans(return_package_handle)


    uri_coerce(uri)


    uri_check_scheme("${uri}" environment)
    ans(ok)

    if(NOT ok)
      return()
    endif()


    return(true)

  endfunction()




return()
  timer_start(t1)
  cmake_environment(--update-cache)
  timer_print_elapsed(t1)

  timer_start(t1)
  cmake_environment()
  ans(res)
  timer_print_elapsed(t1)


  json_print(${res})


  



  return()



  cmake_generator_list()
  cmake_generator_list()
  cmake_generator_list()
  ans(res)

  #define_test_function(test_uut environment)





endfunction()