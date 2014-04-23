function(test)
  
 
  file(WRITE "${test_dir}/f1.txt" "asd")
  
  file_find("${test_dir}/f1.txt" "" "")
  ans(file)
  assert("${file}" STREQUAL "${test_dir}/f1.txt")

  file_find("f1" "${test_dir}" ".txt")
  ans(file)
  assert("${file}" STREQUAL "${test_dir}/f1.txt")



  file(WRITE "${test_dir}/test1/dir1/file2.cmake" "ref_append(\${ref} 1)")
  file(WRITE "${test_dir}/test1/dir1/file1.cmake" "require(file2)\nref_append(\${ref} 2)")

  compile("file1" "${test_dir}/test1/dir1")
  ans(res)
  
  file(WRITE "${test_dir}/p1.cmake" "${res}")

  ref_new()
  ans(ref)
  include("${test_dir}/p1.cmake")
  ref_get(${ref} )
  ans(data)
  assert(EQUALS ${data} 1 2 )



  file(WRITE "${test_dir}/test1/dir1/file3.cmake" "require(file1)\nrequire(file2)\nref_append(\${ref} 3)")
  compile("file3" "${test_dir}/test1/dir1")
  ans(res)
  file(WRITE "${test_dir}/p2.cmake" "${res}")
  ref_new()
  ans(ref)
  include("${test_dir}/p2.cmake")
  ref_get(${ref} )
  ans(data)
 
  assert(EQUALS ${data} 1 2 3)
endfunction()