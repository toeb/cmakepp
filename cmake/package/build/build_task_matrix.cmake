function(build_task_matrix )
  data("${ARGN}")
  ans(config)

  map_tryget(${config} parameters)
  ans(parameters)



  if(parameters)
    map_remove(${config} parameters)    
    map_permutate(${parameters})
    ans(parameters)
  endif()


 
  ## get commands 
  map_tryget(${config} commands)
  ans(commands)
  
  map_coerce("${commands}" "default")
  ans(commands)


  map_tryget(${config} output)
  ans(output)

  map_coerce("${commands}" "default")
  ans(output)


  

  set(tasks)
  while(true)
    list_pop_front(parameters)
    ans(currentMat)
    if(NOT currentMat)
      break()
    endif()

    map_filter_template_key("${commands}" "${currentMat}")
    ans(commandsKey)

    if("${commandsKey}_" STREQUAL "_")
      set(commandsKey default)
    endif()

    map_tryget(${commands} "${commandsKey}")
    ans(commandsTemplate)


    if("${commandsTemplate}_" STREQUAL "_")
      continue()
    endif()


    build_task_new("${commandsKey}" "${commandsTemplate}" "${currentMat}")
    ans(buildTask)

    list(APPEND tasks ${buildTask})
  endwhile()
  return_ref(tasks)
endfunction()