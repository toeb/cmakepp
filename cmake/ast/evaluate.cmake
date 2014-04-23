
  function(evaluate str language expr)
    language(${language})
    ans(language)

    set(scope ${ARGN})
    map_isvalid("${scope}" ismap)
    if(NOT ismap)
      map_create(scope)
      foreach(arg ${ARGN})
        map_set(${scope} "${arg}" ${${arg}})
      endforeach()
    endif()


    map_create(context)
    map_set(${context} scope ${scope})

  #  message("expr ${expr}")

    ast("${str}" ${language} "${expr}")
    #return("gna")
    ans(ast) 
   # ref_print(${ast})
    ast_eval(${ast} ${context} ${language})
    ans(res)
    if(NOT ismap)
      map_promote(${scope})
    endif()
    return_ref(res)
  endfunction()