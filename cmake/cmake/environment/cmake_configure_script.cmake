
## executes a cmake script in configure mode
function(cmake_configure_script script)

   pushtmp()
    cmakepp_config(cmakepp_path)
    ans(cmakepp_path)
      path("output.qm")
      ans(output_file)
      fwrite("CMakeLists.txt" "
        cmake_minimum_required(VERSION 2.8.12)
        include(${cmakepp_path})
        set_ans()
        function(___execute_it)
          ${script}
          return_ans()
        endfunction()
        ___execute_it()
        ans(result)        
        cmake_write(\"${output_file}\" \"\${result}\")
      ") 


      pushd(build --create)
        cmake_lean(".." ${ARGN})
        ans_extract(error)
        ans(stdout)
      popd()
    
    if(error)
      poptmp()
      message(FATAL_ERROR "${stdout}")
    endif()
    cmake_read(${output_file})
    ans(res)
    poptmp()
    return_ref(res)
    

endfunction()