function(test)


  file_directory_isempty(res "${test_dir}")
  assert(res)


  file(WRITE "${test_dir}/hello.txt" "hello")
  file_directory_isempty(res "${test_dir}")
  assert(NOT res)


endfunction()