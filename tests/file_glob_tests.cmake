function(test)


  file(WRITE "${test_dir}/file1.txt"      "asd")
  file(WRITE "${test_dir}/file2.txt"      "asd")
  file(WRITE "${test_dir}/file3.txt"      "asd")
  file(WRITE "${test_dir}/dir1/file1.txt" "asd")
  file(WRITE "${test_dir}/dir1/file2.txt" "asd")
  file(WRITE "${test_dir}/dir1/file3.txt" "asd")


  file_glob("${test_dir}" "**" --relative)
  ans(res)
  message("adda ${res}")
  
  file_glob("${test_dir}" "**")
  ans(res)
  message("adda ${res}")
  
endfunction()