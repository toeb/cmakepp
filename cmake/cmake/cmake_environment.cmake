## `()-> { os:{name:<name>, version:<version>} , processor:}`
## 
## returns the environment of cmake
## the results are cached (--update-cache if necesssary)
function(cmake_environment)
  function(_cmake_environment_inner)
    pushtmp()
    cmakepp_config(cmakepp_path)
    ans(cmakepp_path)
      path("output.qm")
      ans(output_file)
      fwrite("CMakeLists.txt" "
        cmake_minimum_required(VERSION 2.8.12)
        include(${cmakepp_path})
        #get_cmake_property(_cmake_variables VARIABLES)
        set(vars 
          CMAKE_GENERATOR
          CMAKE_SIZEOF_VOID_P
          CMAKE_SYSTEM
          CMAKE_SYSTEM_NAME
          CMAKE_SYSTEM_PROCESSOR
          CMAKE_SYSTEM_VERSION
          CMAKE_HOST_SYSTEM
          CMAKE_HOST_SYSTEM_NAME
          CMAKE_HOST_SYSTEM_PROCESSOR
          CMAKE_HOST_SYSTEM_VERSION
          CMAKE_C_COMPILER_ID
          CMAKE_CXX_COMPILER_ID
        )
        map_new()
        ans(result)
        foreach(var \${vars})
          map_set(\${result} \${var} \${\${var}})
        endforeach()
        qm_write(\"${output_file}\" \"\${result}\")
      ")  


      pushd(build --create)
        _cmake("..")
        ans_extract(error)
        ans(stdout)
      popd()
    
    if(error)
      poptmp()
      message(FATAL_ERROR "${stdout}")
    endif()
    qm_read(${output_file})
    ans(res)
    poptmp()
    set(result)
    assign(!result.os.name = res.CMAKE_HOST_SYSTEM_NAME)   
    assign(!result.os.version = res.CMAKE_HOST_SYSTEM_VERSION) 
    assign(!result.processor = res.CMAKE_HOST_SYSTEM_PROCESSOR)      
    return_ref(result)
  endfunction()
  
  define_cache_function(_cmake_environment_inner => cmake_environment
    --generate-key "[]()checksum_string({{CMAKE_COMMAND}})"
  )
  cmake_environment(${ARGN})
  return_ans()
endfunction()
