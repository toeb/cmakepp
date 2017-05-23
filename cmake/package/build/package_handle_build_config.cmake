
 parameter_definition(package_handle_build_config
    <--package-handle{"recipe map or recipe file"}=>package_handle:<data>>
    <--parameters{"parameters"}=>params:<data>> 
    [--install-dir{"the directory where the build result is moved, relative to target_dir"}=>install_dir:<string>="install"]
    [--target-dir{"default is pwd"}=>target_dir:<string>]
    "#builds a package handle containing a generator"
    "#the generator gets at least the build_dir, install_dir and content_dir as parameters"
    "#the generator needs to ensure that the build results are stored in install_dir"
    )

  function(package_handle_build_config)
    # depending on config build pacage into a directoy - best woudl be human readible folders
    arguments_extract_defined_values(0 ${ARGC} package_handle_build_config)    

    # generates the build direcotry for specified config
    template_run_scoped("${params}" "@string_tolower($system.name)-x@architecture-@compilers.cxx.id@compilers.cxx.version-@config")
    ans(build_id)

    log("build id is '${build_id}'")

    path_qualify(target_dir)

    path_qualify_from("${target_dir}" "${install_dir}")
    ans(install_dir)


    set(install_dir "${install_dir}/${build_id}")


    package_handle_build_cached(
      "${package_handle}" 
      "${params}" 
      --target-dir "${target_dir}"
      --install-dir "${install_dir}"
      ${args}
      )
    ans(build_info)
    
    map_set(${build_info} id "${build_id}")
    return(${build_info})
  endfunction()


