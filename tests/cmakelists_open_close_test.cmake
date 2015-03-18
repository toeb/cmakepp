function(test)



  cmakelists_open()
  ans(cmakelists)
  cmakelists_close(${cmakelists})
  assert(EXISTS CMakeLists.txt)


  pushd(--create dir1)
  cmakelists_open()
  ans(cmakelists)
  assertf({cmakelists.path} STREQUAL "${test_dir}/CMakeLists.txt")



endfunction()