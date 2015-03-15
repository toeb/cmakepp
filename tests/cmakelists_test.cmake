function(test)

  function(cmakelists_open)
    map_new()
    ans(cmakelists)

    path("CMakeLists.txt")
    ans(cmakelists_path)
    if(NOT EXISTS "${cmakelists_path}")
      path_parent_dir_name("cmakelists_path}")
      ans(project_name)
      set(content "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n\nproject(${project_name})")

    else()
      fread("${cmakelists_path}")
      ans(content)
    endif()



    cmake_tokens("${content}")
    ans(tokens)
    map_set(${cmakelists} tokens ${tokens})
    map_set(${cmakelists} path "${cmakelists_path}")
    return_ref(cmakelists)
  endfunction()


  function(cmakelists_close cmakelists) 
    map_tryget(${cmakelists} tokens)
    ans_extract(first)
    cmake_token_range_serialize.cmake("${first}")
    ans(content)
    map_tryget(${cmakelists} path)
    ans(cmakelists_path)
    fwrite("${cmakelists_path}" "${content}")
  endfunction()



  function(cmakelists_add_target cmakelists type)

    
  endfunction()


  pushd(proj1 --create)
  
  cmakelists_open()
  ans(cmakelists)



  cmakelists_close(${cmakelists})



  popd()



endfunction()