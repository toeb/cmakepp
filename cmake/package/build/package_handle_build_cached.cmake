 parameter_definition(package_handle_build_cached
    <--package-handle{"package handle containing a build_descriptor"}=>package_handle:<data>>
    <--parameters{"parameters"}=>params:<data>> 
    [--install-dir{"the directory where the build result is moved, relative to target_dir"}=>install_dir:<string>="install"]
    [--target-dir{"default is pwd"}=>target_dir:<string>]
    "#builds a package handle containing a build_descriptor"
    "#the build_descriptor gets at least the build_dir, install_dir and content_dir as parameters"
    "#the build_descriptor needs to ensure that the build results are stored in install_dir"
    )

  function(package_handle_build_cached)

    set(build_info_file_name ".build-info.json")
    arguments_extract_defined_values(0 ${ARGC} package_handle_build_cached)    

    path_qualify(target_dir)

    log("building package cached '{package_handle.package_descriptor.id}'")


    path_qualify_from("${target_dir}" "${install_dir}")
    ans(install_dir)

    content_dir_check("${install_dir}")
    ans(is_up_to_date)



    if(is_up_to_date)
      log("build is still up to date with result located at '${install_dir}'")
      ## read build descriptor
      fread_data("${install_dir}/${build_info_file_name}")
      return_ans()

    endif()

    if(EXISTS "${install_dir}")
      if(NOT is_up_to_date)
        log("build is incosistent - rebuilding")
      endif()
    else()
      log("build does not exist")
    endif()



    package_handle_build(
      "${package_handle}" 
      "${params}" 
      --target-dir "${target_dir}" 
      --install-dir "${install_dir}"
      ${args})
    ans(build_info)






    fwrite_data("${install_dir}/${build_info_file_name}" "${build_info}")   
    content_dir_update("${install_dir}")

    log("successfully built package cached {package_handle.package_descriptor.id}")
    return(${build_info})
  endfunction()