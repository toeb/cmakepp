function(test)
  

  ## set binary dir
  file_anchor_require_dir(.packages)
  ans(binary_dir)



  ## goto some dir
  pushd(${binary_dir} --create)

  recipe_load("${cmakepp_base_dir}/recipes/tinyxml2.json")
  ans(packageHandle)



  recipe_binary(${packageHandle} {config:'release'})
  ans(result)

  message("${result}")

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