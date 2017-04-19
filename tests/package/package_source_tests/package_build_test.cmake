function(test)
  

  




  ## set binary dir
  file_anchor_require_dir(.packages)
  ans(binary_dir)


  ## load some recipe
  json_read(${cmakepp_base_dir}/recipes/tinyxml2.json)
  ans(recipe)

  ## goto some dir
  pushd(${binary_dir} --create)

  recipe_load("${recipe}")
  ans(packageHandle)


  json_print(${packageHandle})





  function(recipe_require)


  endfunction()
  






endfunction()