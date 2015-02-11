  ## project_open(<path?> [--force]) -> <project>|<null>
  ##
  ## opens an existing project if project does not exist null is returned
  ## if s
  ## --force flag indicates that even if no project exists at specified dir 
  ##              the default configuration will be opened
  function(project_open)
    set(args ${ARGN})

    list_extract_flag(args --force)
    ans(force)

    list_pop_front(args)
    ans(path)

    path_qualify(path)

    set(project_dir)
    if(IS_DIRECTORY "${path}")
      # assume path is project dir -> try to read project config file
      set(project_dir "${path}")
      set(path "${path}/.cps/config.qm")
    endif()



    if(NOT EXISTS "${path}" AND NOT force)
      error("could not find project configuration at {path}")
      return()
    endif()
    
    project_config("${path}")
    ans(config)
    
    if(NOT project_dir)
      map_tryget("${config}" config_file)
      ans(config_file)
      
      string_remove_ending("${path}" "${config_file}")
      ans(project_dir)

      path_qualify(project_dir)
    endif()



    project_new()
    ans(project)


    glob("${project_dir}/package.json" "${project_dir}/package.qm")
    ans(package_descriptor_file)

    list(LENGTH package_descriptor_file count)

    if("${count}" GREATER 1)
      error("multiple package descriptors found (package.json and package.qm)")
      return()
    elseif("${count}" EQUAL 1)
      paths_make_relative("${project_dir}" "${package_descriptor_file}")
      ans(package_descriptor_file)
      map_set("${config}" package_descriptor_file "${package_descriptor_file}")
    endif()


    call(project.load("${project_dir}" "${config}"))
    ans(success)

    if(NOT success)
      return()
    endif()



    return_ref(project)
  endfunction()
