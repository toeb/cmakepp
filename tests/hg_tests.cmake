function(test)

  mkdir("${test_dir}")  
  cd("${test_dir}")

  hg()
  ans(res)
  #message("${res}")

  mkdir("myrepo")
  cd(myrepo)
  hg(init)
  message("${__ans}")
  ls()
  message("${__ans}")

endfunction()