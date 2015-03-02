function(test)


  
  define_test_function(test_uut package_dependency)

  test_uut("" "")
  test_uut("{uri:'heise.de'}" "heise.de")


  test_uut("{content_dir:'.'}" "heise.de" --content-dir ".")
  


endfunction()