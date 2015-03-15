function(test)



  function(cmakelists)
    if(NOT EXISTS "CMakeLists.txt")
      parent_dir_name("CMakeLists.txt")
      ans(project_name)
      set(content "cmake_minimum_required(VERSION ${CMAKE_VERSION})\nproject(${project_name})")
    else()
      fread("CMakeLists.txt")
      ans(content)
    endif()

    cmake_ast("${content}")
    ans(ast)



    return_ref(ast)
  endfunction()




  pushd(proj1 --create)
  







endfunction()