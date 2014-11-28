# compiles a tool (single cpp file with main method)
# and create a cmake function (if the tool is not yet compiled)
# expects tool to print cmake code to stdout. this code will 
# be evaluated and the result is returned  by the tool function
# the tool function's name is name
# currently only allows default headers
function(compile_tool name src)
  checksum_string("${src}")
  ans(chksum)

  oocmake_config(temp_dir)
  ans(tempdir)


  set(dir "${temp_dir}/tools/${chksum}")

  if(NOT EXISTS "${dir}")

    pushd("${dir}" --create)
    fwrite("main.cpp" "${src}")
    fwrite("CMakeLists.txt" "
      project(${name})
      if(\"\${CMAKE_CXX_COMPILER_ID}\" STREQUAL \"GNU\")
        set(CMAKE_CXX_FLAGS \"-std=c++11\")
      endif()
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG   \${CMAKE_BINARY_DIR}/bin)
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE \${CMAKE_BINARY_DIR}/bin)
      set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG   \${CMAKE_BINARY_DIR}/lib)
      set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE \${CMAKE_BINARY_DIR}/lib)
      set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG   \${CMAKE_BINARY_DIR}/lib)
      set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE \${CMAKE_BINARY_DIR}/lib)
      set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/lib)
      set(CMAKE_LIBRARY_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/lib)
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/bin)
      add_executable(${name} main.cpp)
      ")
    mkdir(build)
    cd(build)
    cmake(../ --result)
    ans(configure_result)
    cmake(--build . --result)
    ans(build_result)


    map_tryget(${build_result} result)
    ans(error)
    map_tryget(${build_result} output)
    ans(log)

    if(NOT "${error}" STREQUAL "0")        
      message(FATAL_ERROR "failed to compile tool :\n ${log}")
      rm("${dir}")
    endif()


    popd()
  endif()
  
        
  wrap_executable("__${name}" "${dir}/build/bin/${name}")

  eval("
    function(${name})

      __${name}()
      ans(res)
      eval(\"\${res}\")
      return_ans()
    endfunction()
    ")



endfunction()