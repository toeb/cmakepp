function(project_cmake_export_config project package)
  assign(install = package.package_descriptor.cmake.install)
  if(NOT install)
    return()
  endif()


  map_tryget(${project} content_dir)
  ans(project_dir)
  map_tryget(${project} project_descriptor)
  ans(project_descriptor)
  map_tryget(${project_descriptor} config_dir)
  ans(config_dir)

  print_vars(config_dir project_dir install)

endfunction()



