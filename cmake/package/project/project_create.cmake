## project_create(<project dir> <project config?>) -> <project handle>
##
## creates a project in the specified directory
##
## --force flag deletes all data in the specified project dir 
function(project_create)
  set(args ${ARGN})

  list_extract_flag(args --force)
  ans(force)


  list_pop_front(args)
  ans(project_dir)
  path_qualify(project_dir)

  list_pop_front(args)
  ans(config)
  
  project_config("${config}")
  ans(config)


  if(IS_DIRECTORY "${project_dir}")
      dir_isempty("${project_dir}")
      ans(isempty)
      if(NOT isempty)
        if(force)
        else()
          ## todo: try to create project from existing files
          error("trying to create a project in a non-empty directory (${project_dir}) (use --force if intendend)")
          return()
        endif()
      endif()
  else()
    if(EXISTS "${project_dir}")
      if(NOT force)
        error("specified project_dir ({project_dir}) is an existing file")
        return()
      endif()
      rm("${project_dir}")
      mkdir("${project_dir}")
    else()
      mkdir("${project_dir}")
    endif()
  endif()

  project_new()
  ans(project)


  assign(success = project.load("${project_dir}" "${config}"))

  if(NOT success)
      return()
  endif()

  assign(success = project.save())
  if(NOT success)
    return()
  endif()

  return_ref(project)
endfunction()