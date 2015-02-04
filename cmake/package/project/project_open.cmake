  ## project_open(<path?>) -> <project>|<null>
  ##
  ## opens an existing project if project does not exist null is returned
  ## if s
  function(project_open)
    set(args ${ARGN})
    list_pop_front(args)
    ans(path)

    path_qualify(path)

    set(project_dir)
    if(IS_DIRECTORY "${path}")
      # assume path is project dir -> try to read project config file
      set(project_dir "${path}")
      set(path "${path}/.cps/config.qm")
    endif()


    if(NOT EXISTS "${path}")
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


    call(project.load("${project_dir}" "${config}"))
    ans(success)

    if(NOT success)
      return()
    endif()



    return_ref(project)
  endfunction()
