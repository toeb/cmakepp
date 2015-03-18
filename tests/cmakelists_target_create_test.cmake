function(test)


  cmakelists_open()
  ans(cmakelists)


  cmakelists_target_create(${cmakelists} library mylib)

  cmakelists_close(${cmakelists})


  fread("CMakeLists.txt")
  ans(content)

  assert("${content}" MATCHES "add_library\\(mylib")

endfunction()