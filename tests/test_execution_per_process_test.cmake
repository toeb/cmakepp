function(test)
return()

  function(test_execute_process test)
    message(STATUS "running test ${test}...")

    #initialize variables which test can use
    set(test_name "${test}")


    # setup a directory for the test
    string_normalize("${test}")
    ans(test_dir)
    oocmake_config(temp_dir)
    ans(temp_dir)
    set(test_dir "${temp_dir}/tests/${test_dir}")
    file(REMOVE_RECURSE "${test_dir}")
    get_filename_component(test_dir "${test_dir}" REALPATH)
    
    message(STATUS "test directory is ${test_dir}")  
    pushd("${test_dir}" --create)
    call("${test}"())
    ans(time)
    popd()

  endfunction()



  function(fork)



  endfunction()


  fwrite("fork.cmake" "
    foreach(i RANGE 0 10)
      message(\${i})
      execute_process(COMMAND \${CMAKE_COMMAND} -E sleep 1)
    endforeach()
    message(end)
    ")
  


  shell_get()
  ans(cmd)

  if("${cmd}" STREQUAL "cmd")
    # windows shell - use start

  endif()

  oocmake_config(base_dir)
  ans(bd)

  wrap_executable(sp "${bd}/resources/exec_windows.bat")
  wrap_executable(cmd "cmd")
  wrap_executable(tasklist "tasklist")
  wrap_executable(taskkill "taskkill")


  #cmd(/C start cmake -P fork.cmake)
#  ans(res)
  pwd()
  ans(path)



  sp(-exec "${CMAKE_COMMAND} -P fork.cmake > currentout.txt" -workdir "${path}" --result)
  ans(res)


  map_tryget(${res} output)
  ans(stdout)

  string(REGEX MATCH "[1-9][0-9]*" pid "${stdout}")
  message("processid is ${pid}")





  #tasklist()
  #ans(res)
  #message("print ${res}")

  json_print(${res})




  sleep(5)
  fread("currentout.txt")
  ans(res)
  message("print ${res}")


 # taskkill(/PID ${pid})



endfunction()