

parameter_definition(package_handle_build_descriptor
    <--package-handle:<map>>
)
function(package_handle_build_descriptor)
  arguments_extract_defined_values(0 ${ARGC} package_handle_build_descriptor)    
  


  map_tryget(${package_handle} build_descriptor)
  ans(build_descriptor)

  if(build_descriptor)
    log("package handle has a custom build descriptor")
    return(${build_descriptor})
  endif()

  

  build_descriptor_generate(${package_handle})
  ans(res)

  return_ref(res)  
endfunction()




function(build_descriptor_generator_register build_descriptor_function)
  map_append(global build_descriptor_generators ${build_descriptor_function})
endfunction()

function(build_descriptor_generators)
  map_get(global build_descriptor_generators)
  return_ans()
endfunction()


task_enqueue("[]() build_descriptor_generator_register(package_handle_build_descriptor_generate_cmake)" )


function(build_descriptor_generate package_handle)
  build_descriptor_generators()
  ans(generators)
  foreach(generator ${generators})
    log("trying to generate build_descriptor with generator '${generator}'")
    call("${generator}(${package_handle})")
    ans(res)
    if(res)
      log("succesfully generated build descriptor using '${generator}'")
      return_ref(res)
    else()
      log("failed to  generate build descriptor using '${generator}'")
    endif()
  endforeach()
  return()
endfunction()


function(package_handle_build_descriptor_generate_cmake package_handle)
  map_tryget(${package_handle} content_dir)
  ans(content_dir)

  if(NOT content_dir)
    log("could not generate a build descriptor because package_handle does not have a content dir")
    return()
  endif()  

  ## curretnly only know of an auto cmake build_descriptor
  if(EXISTS "${content_dir}/CMakeLists.txt")
    log("package contains a root level CMakeLists.txt - an automatic build descriptor is being generated")
    map_new()
    ans(gen)
    map_append(${gen} commands "shell>cmake -G \"@generator\" -DCMAKE_INSTALL_PREFIX=\"@install_dir\" \"@content_dir\"")
    map_append(${gen} commands "shell>cmake --build . --target install --config @config")
    return(${gen})
  endif()

endfunction()