function(cmakepp_configure project_path)
  print_Vars(project_path)

  pwd()
  ans(cwd)
  print_Vars(cwd)


  
  if(NOT EXISTS "${project_path}/CMakeLists.txt")
    throw("no cmakelists found")
  endif()


  pushd(--create "${project_path}/build")


  cmake(..)
  
  popd()




  return(ok)

endfunction()