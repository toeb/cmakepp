
  
  function(recipe_build)
    recipe_load(${ARGN})
    ans(package_handle)

    if(NOT package_handle)
      return()
    endif()


    build_params()
    ans(build_params)

    package_handle_build_config("${package_handle}" "${build_params}") 
    ans(build_descriptor)

    return_ref(package_handle)
  endfunction()

