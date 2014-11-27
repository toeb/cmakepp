function(test)
#compiles a tool and create a cmake function
    function(compile_command name src)
      file_tempdir()
      ans(dir)
     message("tool dir ${dir}") 
      pushd("${dir}")
      fwrite("main.cpp" "${src}")
      fwrite("CMakeLists.txt" "
        project(${name})
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


      json_print(${configure_result})
      message("res ${res}") 
      popd()
      

      wrap_executable("${name}" "${dir}/")

    endfunction()
  

    compile_command(sayhello "#include <iostream>\n int main(int argc, const char ** argv){ std::cout << \"message(whatup)\" << std::endl;}")
    sayhello(--result)
    ans(res)
    json_print(${res})


endfunction()