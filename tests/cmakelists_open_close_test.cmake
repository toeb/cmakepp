function(test)



  cmakelists_open()
  ans(cmakelists)
  assert(NOT cmakelists)


  fwrite(CMakeLists.txt)
  cmakelists_open()
  ans(cmakelists)


  json_print(${cmakelists})


  


  message("${my_path}")

  assert(cmakelists)

return()


  cmakelists_close(${cmakelists})
  assert(EXISTS CMakeLists.txt)


  pushd(--create dir1)
  cmakelists_open()
  ans(cmakelists)
  assertf({cmakelists.path} STREQUAL "${test_dir}/CMakeLists.txt")



endfunction()