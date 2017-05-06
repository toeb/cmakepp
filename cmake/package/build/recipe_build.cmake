
  
function(recipe_build)
  recipe_load(${ARGN})
  ans(package_handle)

  if(NOT package_handle)
    return()
  endif()


  build_params()
  ans(build_params)

  package_handle_build_config("${package_handle}" "${build_params}") 
  ans(build)

  map_append(${package_handle} builds ${build})  
  
  return_ref(package_handle)
endfunction()



