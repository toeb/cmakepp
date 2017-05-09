function(test)
 # rm(-r d:/test1)
  cd("d:/test1" --create)

  cmake_configure_script("
      recipe_load(${cmakepp_base_dir}/recipes/tinyxml2.json)
      ans(recipe)  
      package_handle_build_configurations(\${recipe})
    "

    --passthru)
  ans(res)
  #json_print(${res})
  return()

  if(NOT EXISTS "d:/test1")
    cd("d:/test1" --create)


    cmake_configure_script(" 
        foreach(configType \${CMAKE_CONFIGURATION_TYPES})
          message(\${configType})
          build_params(--config \${configType})
          ans(params)
          pushd(d:/test1)
          recipe_build(${cmakepp_base_dir}/recipes/tinyxml2.json --build-params \${params})     
        endforeach()      
      " 
      --target-dir "d:/test1/cmake"
      --passthru)

  endif()



    function(package_handle_builds_load path)
      path_qualify(path)

      glob("${path}/**/.build-info*")
      ans(paths)
      json_print(${paths})
      set(builds)
      foreach(path ${paths})
        fread_data("${path}")
        ans(data)
        
        json_print(${data})
      endforeach()
      return_ref(builds)
    endfunction()

    function(package_handle_build_filter build_list)

    endfunction()





    package_handle_builds_load("d:/test1/install")
    ans(builds)

    json_print(${builds})

  return()
  

  return()

  pushd(tinyxml2 --create)
  ## furst thing - how do i get the build params to --build > (maybe also trhough uri?)
  ## how do i cash the package name once?
  recipe_build("${cmakepp_base_dir}/recipes/tinyxml2.json")
  ans(res)
  #recipe_build("https://github.com/leethomason/tinyxml2.git?tag=4.0.1")
  json_print(${res})
  popd()




  return()


  ## set binary dir
  file_anchor_require_dir(.packages)
  ans(binary_dir)



  ## goto some dir
  pushd(${binary_dir} --create)

  recipe_load("${cmakepp_base_dir}/recipes/tinyxml2.json")
  ans(packageHandle)





  package_handle_binary_generator(${packageHandle})
  ans(result)





  json_print(${result})



return()


  build_params(--generator "Visual Studio 15 2017 Win64" --release)
  ans(param)
  package_handle_build_config("${packageHandle}" "${param}")
  ans(descr)


  build_params(--generator "Visual Studio 15 2017 Win64" --debug)
  ans(param)
  package_handle_build_config("${packageHandle}" "${param}")
  ans(descr)

  build_params(--generator "Visual Studio 15 2017" --release)
  ans(param)
  package_handle_build_config("${packageHandle}" "${param}")
  ans(descr)

  build_params(--generator "Visual Studio 15 2017" --debug)
  ans(param)
  package_handle_build_config("${packageHandle}" "${param}")
  ans(descr)


  build_params(--generator "Visual Studio 14 2015 Win64" --debug)
  ans(param)
  package_handle_build_config("${packageHandle}" "${param}")
  ans(descr)
  
  build_params(--generator "Visual Studio 14 2015 Win64" --release)
  ans(param)
  package_handle_build_config("${packageHandle}" "${param}")
  ans(descr)



  build_params(--generator "Visual Studio 14 2015" --debug)
  ans(param)
  package_handle_build_config("${packageHandle}" "${param}")
  ans(descr)


  build_params(--generator "Visual Studio 14 2015" --release)
  ans(param)
  package_handle_build_config("${packageHandle}" "${param}")
  ans(descr)




return()
    


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