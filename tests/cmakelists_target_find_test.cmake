function(test)



  cmakelists_new("
    add_test(my_test asd)
    add_executable(my_lib2 sourceA.c)
    target_compile_options(my_lib2 asdasd)
    add_library(my_lib source1.c source2.cpp)
    target_link_libraries(my_lib asd bsd)
    target_include_directories(my_lib dir1/dir2 dir3)
    ")
  ans(cmakelists)


  cmakelists_targets(${cmakelists} my_lib2?)
  ans(targets)
  assertf("{targets.my_lib2}" ISNOTNULL)
  assertf("{targets.my_lib2.target_source_files}" STREQUAL sourceA.c)
  assertf("{targets.my_lib2.target_compile_options}" STREQUAL asdasd)
  assertf("{targets.my_lib2.target_type}" STREQUAL executable)
  assertf("{targets.my_lib2.target_invocations}" ISNOTNULL)  
  assertf("{targets.my_lib}" ISNOTNULL)
  assertf("{targets.my_lib.target_name}" STREQUAL my_lib)
  assertf("{targets.my_lib.target_type}" STREQUAL library)
  assertf("{targets.my_lib.target_source_files}" EQUALS source1.c source2.cpp)

  assertf("{targets.my_test}" ISNULL)


endfunction()