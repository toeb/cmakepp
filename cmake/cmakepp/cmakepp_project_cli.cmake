## 
##
## invokes the cmakepp project command line interface
function(cmakepp_project_cli)
  #commandline_args_get(--no-script)
  #ans(args)
  set(args ${ARGN})

  list_extract_flag(args --save)
  ans(save)


  list_extract_labelled_value(args --project)
  ans(project_dir)

  project_open("${project_dir}")
  ans(project)

  map_tryget(${project} project_descriptor)
  ans(project_descriptor)
  map_tryget(${project_descriptor} package_source)
  ans(package_source)
  if(NOT package_source )
    message("no package source found")
    default_package_source()
    ans(package_source)
    map_set(${project_descriptor} package_source ${package_source})
  endif()
  list_pop_front(args)
  ans(cmd)


  if(NOT cmd)
    set(cmd run)
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
    call("project_${cmd}"("${project}" ${args}))
    ans(res)
  endif()

  project_close(${project})
  return_ref(res)

endfunction()