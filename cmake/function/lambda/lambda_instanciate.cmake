

  function(lambda2_instanciate source)
    checksum_string("${source}")
    ans(hash)
    map_tryget(__lambdas_lookup "${hash}")
    ans(lambda)
    if(lambda)
      return(${lambda})
    endif()

    lambda2_compile("${source}")
    ans(lambda)

    map_tryget(${lambda} capture)
    ans(captures)
    set(capture_code)    
    foreach(capture ${captures})
      set(capture_code "${capture_code}\n  set(${capture} \"${${capture}}\")")
    endforeach()


    set(function_name ${ARGN})
    if(NOT function_name)
      function_new()
      ans(function_name)
    endif()

    map_set(${lambda} function_name ${function_name})

    map_tryget(${lambda} cmake_source)
    ans(cmake_source)
    map_tryget(${lambda} signature)
    ans(signature) 
    set(source "function(${function_name} ${signature})${capture_code}\n${cmake_source}\nendfunction()")
    message("${source}")
    eval("${source}")
    map_set(${lambda} cmake_function "${source}")
    map_set(__lambdas_lookup "${hash}" "${lambda}")
    map_set(__lambdas "${function_name}" "${lambda}")
    return_ref(lambda)
  endfunction()
