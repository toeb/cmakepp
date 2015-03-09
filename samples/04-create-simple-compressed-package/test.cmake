function(test)

  default_package_source_set(archive)


  sample_copy("04")


  # create a file containing the function that you want to load
  # a note to the name: the function name should be globally unique
  # - cmake has a single global scope for functions so it would be
  # wise to prepend some sort of namespace for all your cmake functions
  # 
  fwrite("cmake/my_sample_function.cmake" "
    ## this function generates a cpp main function file 
    ## which when compiled and executed will return 42
    function(my_sample_function)
      fwrite(main.cpp \"
        #include <iostream>
        int main(){
          std::cout<< 42 <<std::endl;
        }
      \")
      ans(path)
      return_ref(path)
    endfunction()
  ")

  ## write the package descriptor in json format
  ## this package descriptor tells cmakepp to include all files 
  ## in the cmake folder and to load the my_sample_function.cmake
  ## file when the package is used
  ##
  ## `cmakepp.export` tells cmakepp to load all exported cmake files
  ##    when the package is loaded 
  ## `content` tells the package source which files
  ##    are included in the package (the default is **) 
  fwrite_data("package.cmake" --json 
  "{
    content:['cmake/**','package.cmake'],
    cmakepp:{
      export:[
        'cmake/my_sample_function.cmake'
      ]
    }    
  }")


  ## push the package into a compressed file
  ## if the package decriptor does not specify which files
  ## are to be pushed all files of th package directory are used
  path_package_source()
  ans(path_source)
  package_source_push_archive(${path_source} "." => "my_package.tgz")

  ## check that the package was created
  assert(EXISTS "${test_dir}/my_package.tgz")



  ### using installing and using the package manager

  cd("project_dir")
  ## compile cmakepp to a single file in project dir
  cmakepp_compile("cmakepp.cmake")

  ## when cmakepp is installed you can use this command from the console
  pkg(materialize "../my_package.tgz")
  ans(res)
  assert(res)


  ## create a build dir 
  ## configure project 
  ## build project 
  ## execute resulting executable
  mkdir("build")
    cd("build")
      cmake(
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=bin 
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=bin  
      ..)
      cmake(--build .)

      execute("bin/myexe")
      ans(res)


 ## check that output matches the expected value
 assert("${res}" MATCHES 42)







endfunction()