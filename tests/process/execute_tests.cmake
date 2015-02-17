function(test)
##
  mkdir("dir1")
  fwrite(dir1/successscript.cmake "message(STATUS hello)")
  fwrite(dir1/errorscript.cmake "message(FATAL_ERROR byebye)")

  ## act
  execute(${CMAKE_COMMAND} -P successscript.cmake TIMEOUT 3 WORKING_DIRECTORY dir1 --handle)
  ans(res)

  ## assert
  assertf("{res.start_info.command}" STREQUAL "${CMAKE_COMMAND}")
  assertf("{res.start_info.command_arguments}" CONTAINS -P  )
  assertf("{res.start_info.command_arguments}" CONTAINS successscript.cmake  )

  path("dir1")
  ans(cwd)
  assertf("{res.start_info.working_directory}" STREQUAL "${cwd}")
  assertf("{res.exit_code}" EQUAL 0)

  assertf("{res.stdout}" MATCHES "hello")
  assertf("{res.start_info.timeout}" EQUAL 3)

  ## act
  execute(${CMAKE_COMMAND} -P errorscript.cmake WORKING_DIRECTORY dir1 --handle)
  ans(res)

  ## assert
  assertf("{res.start_info.command}" STREQUAL "${CMAKE_COMMAND}")
  assertf("{res.start_info.command_arguments}" CONTAINS -P )
  assertf("{res.start_info.command_arguments}" CONTAINS errorscript.cmake )

  path("dir1")
  ans(cwd)
  assertf("{res.start_info.working_directory}" STREQUAL "${cwd}")
  assertf("{res.stderr}" MATCHES "byebye")
  assertf(NOT "{res.exit_code}" EQUAL 0)



  execute(COMMAND cmake -E echo_append "hello;hello" turn the radio on --handle)
  ans(res)
  assertf("{res.stdout}" EQUALS "hello;hello turn the radio on" )



endfunction()