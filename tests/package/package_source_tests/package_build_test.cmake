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

   parameter_definition(build_cached
    <--package-handle{""}:<data>>
    [--cache-dir{"the directory of the cache for the specified package-handle"}=>cache_dir:<string>]    
    "#returns a cached build or builds and caches a build"
    )




   function(cached_path)


   endfunction()

  function(build_cached )
    arguments_extract_defined_values(0 ${ARGC} build_cached)    


    # needs to react if package handle | content changed
    # needs to react on different parameters


  endfunction()


  package_handle_build(${packageHandle} {config:'release'})
  ans(result)


  map_tryget(${result} install_dir)
  ans(install_dir)


  checksum_dir("${install_dir}")
  ans(chk1)
  message("${chk1}")

  fwrite("${install_dir}/test.txt")
  checksum_dir("${install_dir}")
  ans(chk1)
  message("${chk1}")

  checksum_dir("${install_dir}" test.txt)
  ans(chk1)
  message("${chk1}")




  package_handle_build(${packageHandle} {config:'release'})




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