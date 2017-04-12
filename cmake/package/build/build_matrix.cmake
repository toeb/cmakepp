  function(build_matrix )
    data("${ARGN}")
    ans(config)

    map_tryget(${config} matrix)
    ans(buildMatrices)


    if(buildMatrices)
      map_permutate(${buildMatrices})
      ans(buildMatrices)
    endif()


    ## get generators 
    map_tryget(${config} generator)
    ans(generators)

    map_coerce("${generators}" "default")
    ans(generators)


    set(tasks)

    while(true)
      list_pop_front(buildMatrices)
      ans(currentMat)
      if(NOT currentMat)
        break()
      endif()

      map_filter_template_key("${generators}" "${currentMat}")
      ans(generatorKey)

      if("${generatorKey}_" STREQUAL "_")
        set(generatorKey default)
      endif()

      map_tryget(${generators} "${generatorKey}")
      ans(generatorTemplate)


      if("${generatorTemplate}_" STREQUAL "_")
        continue()
      endif()

      template_run_scoped(${currentMat} "${generatorTemplate}")
      ans(generatorEvaluated)

      map_new()
      ans(buildTask)
      map_set(${buildTask} name "${generatorKey}")
      map_set(${buildTask} commands "${generatorTemplate}")
      map_set(${buildTask} parameters ${currentMat})

      list(APPEND tasks ${buildTask})
    endwhile()
    return_ref(tasks)
  endfunction()