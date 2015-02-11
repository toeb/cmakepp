## 
##
## invokes the cmakepp project command line interface
function(cmakepp_project_cli)
  #commandline_args_get(--no-script)
  #ans(args)
  set(args ${ARGN})

  list_extract_flag(args --save)
  ans(save)

 # list_extract_flag(args cmakepp_project_cli)

  list_extract_labelled_value(args --project)
  ans(project_dir)

  project_open("${project_dir}" --force)
  ans(project)



  list_pop_front(args)
  ans(cmd)


  if(NOT cmd)
    return_ref(project)
  endif()


  if("${cmd}" STREQUAL "set")
    list_pop_front(args)
    ans(path)
    if(NOT path)
      error("no path specified")
      return()
    endif()
    assign("!project.${path}" = "'${args}'")
    set(save true)
    assign(res = "project.${path}")

  elseif("${cmd}" STREQUAL "run")
    package_handle_invoke_hook("${project}" cmakepp.hooks.run "${project}" "${project}")
    ans(res)
  else()
    assign(res = "project.${cmd}")

    if(COMMAND "${res}" )
      assign(res = "project.${cmd}"(${args}))
    endif()
  endif()

  if(save)
    assign(saved = project.save())
    if(NOT saved)
      error("could not save project")
      return()
    endif()
  endif()

  return_ref(res)

endfunction()