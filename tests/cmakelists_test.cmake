function(test)



  pushd(proj1 --create)
  
  cmakelists_open()
  ans(cmakelists)


  cmakelists_add_target(${cmakelists} library my_lib)
  cmakelists_add_target(${cmakelists} library my_lib2)
  cmakelists_add_target(${cmakelists} executable my_lib3)

  cmakelists_target_add_source_files("${cmakelists}" "my_lib" "hihi.cpp" "huhu.h" --append)
  cmakelists_target_add_source_files("${cmakelists}" "my_lib" "gaga.cpp" "blublu.h" --append)
  pushd(dir1 --create)
    cmakelists_target_add_source_files("${cmakelists}" "my_lib" "gaganana.cpp" "blublsssu.h" --append)
    cmakelists_target_add_source_files("${cmakelists}" "my_lib" "gagaasdasd.cpp" "blubludd.h" --append)
  popd()
  cmakelists_target_add_source_files("${cmakelists}" "my_lib" --sort)


  cmakelists_close(${cmakelists})

  cmakelists_open()
  ans(cmakelists)
    cmakelists_managed_targets(${cmakelists})
  ans(res)

  json_print(${res})

  popd()



endfunction()