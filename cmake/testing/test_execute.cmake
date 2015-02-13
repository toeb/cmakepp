function(test_execute test)

  message(STATUS "running test ${test}...")

  #initialize variables which test can use

#  set(test_name "${test}")
  get_filename_component(test_name "${test}" NAME_WE) 

  # intialize message listener

  # setup a directory for the test
  string_normalize("${test_name}")
  ans(test_dir)
  cmakepp_config(temp_dir)
  ans(temp_dir)
  set(test_dir "${temp_dir}/tests/${test_dir}")
  file(REMOVE_RECURSE "${test_dir}")
  get_filename_component(test_dir "${test_dir}" REALPATH)
  
  message(STATUS "test directory is ${test_dir}")  
  pushd("${test_dir}" --create)
  timer_start("test duration")
  call("${test}"())
  
  set(time)
  timer_elapsed("test duration")
  ans(time)
  popd()


  message(STATUS "done after ${time} ms")
endfunction()
