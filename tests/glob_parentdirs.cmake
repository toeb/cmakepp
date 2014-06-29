function(test)


  path_relative("c:/test" "e:/test3")
  ans(res)
  assert("${res}" STREQUAL "e:/test3")

  
  path_relative("c:/test1/test3" "c:/test1/test2/test3" )
  ans(res)
  assert("${res}" STREQUAL "../test2/test3")
 

  


  path_parent_dirs("c:/dir1/dir2/file.ext")
  ans(dirs)
  assert(EQUALS ${dirs} c:/dir1/dir2 c:/dir1 c:)



  path_split("c:/dir1/dir2/file.ext")
  ans(res)
  assert(EQUALS ${res} c: dir1 dir2 file.ext)

  path_split("")
  ans(res)
  assert(NOT res)

  path_split("/test/test/test")
  ans(res)
  assert(EQUALS ${res} test test test)


  path_split("test")
  ans(res)
  assert(EQUALS ${res} test)






  mkdir("dir1")
  mkdir("dir11")
  file_write("f11.txt" "asd")
  file_write("f12.txt" "asd")

  mkdir(dir2)
  pushd("dir2")
  file_write("f21.txt" "asd")
  file_write("f22.txt" "asd")

  mkdir(dir3)
  pushd(dir3)
  file_write("f31.txt" "asd")
  file_write("f32.txt" "asd")

  file_glob_up("." 2 *.txt)
  ans(res_gl)



  popd()
  popd()


  file_glob("${test_dir}" ** --recurse)
  ans(res)




endfunction()