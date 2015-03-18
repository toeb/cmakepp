
  function(package_cmake_module_content package module)
    map_import_properties(${package} content_dir)

    map_import_properties(${module} 
      add_as_subdirectory
      include_dirs
     )
    pushd(${content_dir})
    paths(${include_dirs})
    ans(include_dirs)
    if(NOT include_dirs)
      set(include_dirs ${content_dir})
    endif()
    popd()
    assign(module_name = package.package_descriptor.id)
   # string(TOUPPER "${module_name}" module_name)
    format("##
set({module_name}_DIR \"{content_dir}\")
set({module_name}_INCLUDE_DIRECTORIES ${include_dirs})
set({module_name}_FOUND \"{content_dir}\")

")
    ans(result)
    if(add_as_subdirectory)
      set(result "${result}add_subdirectory(\${${module_name}_DIR})" )
    endif()
    return_ref(result)
  endfunction()
