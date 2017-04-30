function(test)





  cmake_environment()
  ans(env)


  ## set binary dir
  file_anchor_require_dir(.packages)
  ans(binary_dir)



  ## goto some dir
  pushd(${binary_dir} --create)

  recipe_load("${cmakepp_base_dir}/recipes/tinyxml2.json")
  ans(packageHandle)



    


  timer_start("initial build")
  package_handle_build_cached(${packageHandle} {config:'release'})
  ans(result)
  timer_print_elapsed("initial build")


  timer_start("second build")
  package_handle_build_cached(${packageHandle} {config:'release'})
  ans(result)
  timer_print_elapsed("second build")


  timer_start("third build")  
  fwrite("install/dummy.txt")
  package_handle_build_cached(${packageHandle} {config:'release'})
  ans(result)
  timer_print_elapsed("second build")




return()
  package_handle_build(${packageHandle} {config:'release'})
  ans(result)


  assign(install_dir = result.params.install_dir)

print_vars(install_dir)

  checksum_dir("${install_dir}")
  ans(chk1)
  message("${chk1}")

  fwrite("${install_dir}/test.txt" "mu")
  checksum_dir("${install_dir}")
  ans(chk1)
  message("${chk1}")

  checksum_dir("${install_dir}" test.txt)
  ans(chk1)
  message("${chk1}")




  pushd(${install_dir})
  checksum_glob_ignore("**" "!test.txt" --recurse)
  ans(chk1)
  popd()
  message("${chk1}")






  #package_handle_build(${packageHandle} {config:'release'})




  json_print("${result}")

return()
  json_print(${packageHandle})





  recipe_load("${cmakepp_base_dir}/recipes/tinyxml2.json")
  ans(packageHandle)

  json_print(${packageHandle})



  fwrite("source/values.txt")
  recipe_load("${cmakepp_base_dir}/recipes/tinyxml2.json")
  ans(packageHandle)

  json_print(${packageHandle})


endfunction()