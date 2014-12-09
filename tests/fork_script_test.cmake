function(test)
  
  
  cd(dir1 --create)
  ans(path)
  
  # fork a single script which waits 3 seconds then writes to test.txt in cwd
  set($ENV{greeting} buhuhuhu)
  process_fork_script("
    execute_process(COMMAND \${CMAKE_COMMAND} -E sleep 2)
    file(WRITE test.txt hello \$ENV{greeting})
  ")

  ans(ph)

  ## file should not be created yet
  assert(NOT EXISTS "${test_dir}/dir1/test.txt")

  ## wait for script to complete
  process_wait_all(${ph})

  # assert that file was written
  assert(EXISTS "${test_dir}/dir1/test.txt")
  fread(test.txt)
  ans(res)

  #assert("${res}" STREQUAL "buhuhuhu")
  

  cd(../dir2 --create)





  set(script "
    foreach(i RANGE 0 10)
      message(\${i})
      execute_process(COMMAND \${CMAKE_COMMAND} -E sleep 1)
    endforeach()
    message(end)
    ")

  process_fork_script("${script}")
  ans(pi1)
  process_fork_script("${script}")
  ans(pi2)
  process_fork_script("${script}")
  ans(pi3)


  process_wait_all(${pi1} ${pi2} ${pi3})
  ans(res)
  json_print(${res})

  process_wait_all(${pi1} ${pi2} ${pi3})
  ans(res)
  json_print(${res})

  return()


  endfunction()