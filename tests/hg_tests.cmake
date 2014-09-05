function(test)

  find_package(Hg)
  if(NOT HG_FOUND)
    message("Test Inconclusive, missing mercurial")
    return()
  endif() 


  mkdir("${test_dir}")  
  cd("${test_dir}")

  

  mkdir("myrepo")

  cd(myrepo)
  fwrite(test1 "some data")
  fwrite(test2 "some more data")


  hg(init)
return()
  hg(add)
  hg(commit -m "some commit")


  cd(..)
  hg(clone ${test_dir}/myrepo copyofrepo)
  cd(copyofrepo)
  fwrite(test3 "lalal")
  hg(add)
  hg(commit -m "yay")
  hg(push)




endfunction()