
  function(project_cmake_export_module project package)
    assign(module = package.package_descriptor.cmake.module)
    if(NOT module)
      return()
    endif()

    assign(module_name = package.package_descriptor.id)
    if(NOT module_name)
      error("project_cmake_export_module: package requires a id unique to project.")
      return()
    endif()

    set(module_file_name "Find${module_name}.cmake")

    project_cmake_constants()

    map_tryget(${package} content_dir)
    ans(package_dir)
    map_tryget(${project} content_dir)
    ans(project_dir)

    map_get_map(${project} cmake_descriptor)
    ans(cmake_descriptor)

    map_get_default(${cmake_descriptor} module_dir "${project_cmake_module_dir}")
    ans(module_dir)


    path_qualify_from("${project_dir}" "${module_dir}")
    ans(module_dir)

    print_vars(package_dir module_dir project_dir module_name)

    path_qualify_from("${module_dir}" "${module_file_name}")
    ans(module_file_path)


    if(NOT EXISTS "${module_file_path}")
      ## get module content
      package_cmake_module_content("${package}" "${module}")
      ans(module_content)
      fwrite("${module_file_path}" "${module_content}")
    endif()

    if(NOT EXISTS "${module_dir}/Findcmakepp.cmake")
      cmakepp_config(cmakepp_path)
      ans(cmakepp_path)
      fwrite("${module_dir}/Findcmakepp.cmake" "
        include(\"${cmakepp_path}\")
        " )


    endif()

    return()
  endfunction()
