function(test)
  ## get sample into pwd
  sample_copy("02")
  
  ## compile current cmakepp version into standalone cmakepp.cmake
  ## file in current directory  
  cmakepp_compile("cmakepp.cmake")


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
 
  ## build the projec tin the binary dir
  cmake(--build .)

  ## run the built executable
  execute("bin/myexe")
  ans(res)

  ## check that the executable outputs the expected value
  assertf("{res.stdout}" MATCHES "^hello")

  

endfunction()