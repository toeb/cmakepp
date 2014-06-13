function(test)



  file_configure_write("${test_dir}/dir1" "text1.txt" "hello world")
  assert(EXISTS "${test_dir}/dir1/text1.txt")
  file(READ "${test_dir}/dir1/text1.txt" ctn)
  assert("${ctn}" MATCHES "hello world")






  map()
    kv("file1.txt" "content1")
    kv("file2.txt" "content2")
    kv("dir1/file1.txt" "content3")
  end()
ans(file_map)



file_configure_write_map("${test_dir}/dir2" ${file_map})
assert(EXISTS "${test_dir}/dir2/file1.txt")
assert(EXISTS "${test_dir}/dir2/file1.txt")
assert(EXISTS "${test_dir}/dir2/dir1/file1.txt")

set(myvar hello)
map()
kv("{myvar}.txt" "content@myvar@")
end()
ans(file_map)
file_configure_write_map("${test_dir}/dir3" ${file_map})
ans(res)
assert(FILE_CONTAINS "${test_dir}/dir3/hello.txt" "contenthello")
assert(${res} STREQUAL "${test_dir}/dir3/hello.txt")
endfunction()