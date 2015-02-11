function(test)

  ## copies the sample to the current dir
  sample_copy("01")

  ## create a build directory
  mkdir("build")
  cd("build")

  ## run cmake in build directory
  ## to configure parent directory 
  ## set output directories for executable to bin 
  cmake(
    -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=bin 
    -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=bin  
    ..)

  ## build the project in the binary dir
  cmake(--build .)

  ## run the built executable
  execute("bin/myexe")
  ans(res)

  

 

endfunction()