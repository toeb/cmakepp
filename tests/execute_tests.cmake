function(test)

  

  mkdir("dir1")
  fwrite(dir1/successscript.cmake "message(hello)")
  fwrite(dir1/errorscript.cmake "message(FATAL_ERROR byebye)")

  ## act
  execute("{
    path:$CMAKE_COMMAND,
    args:['-P', 'successscript.cmake'],
    timeout: 3,
    cwd: 'dir1'
  }")
  ans(res)

  ## assert
  assert(DEREF "{res.path}" STREQUAL "${CMAKE_COMMAND}")
  assert(DEREF CONTAINS -P "{res.args}" )
  assert(DEREF CONTAINS successscript.cmake "{res.args}" )

  path("dir1")
  ans(cwd)
  assert(DEREF "{res.cwd}" STREQUAL "${cwd}")
  assert(DEREF "{res.output}" MATCHES "hello")
  assert(DEREF "{res.result}" EQUAL 0)
  assert(DEREF "{res.timeout}" EQUAL 3)

  ## act
  execute("{
    path:$CMAKE_COMMAND,
    args:['-P', 'errorscript.cmake'],
    cwd:'dir1'
  }")
  ans(res)

  ## assert
  assert(DEREF "{res.path}" STREQUAL "${CMAKE_COMMAND}")
  assert(DEREF CONTAINS -P "{res.args}" )
  assert(DEREF CONTAINS errorscript.cmake "{res.args}" )

  path("dir1")
  ans(cwd)
  assert(DEREF "{res.cwd}" STREQUAL "${cwd}")
  assert(DEREF "{res.output}" MATCHES "byebye")
  assert(DEREF NOT "{res.result}" EQUAL 0)

endfunction()