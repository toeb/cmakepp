
  ## `(<~package dependency>)-><package dependency>`
  ##
  ##
  function(package_dependency)
    ref_isvalid("${ARGN}")
    ans(ismap)
    if(ismap)
      map_has("${ARGN}" uri)
      ans(has_uri)
      if(NOT has_uri)
        return()
      endif()
      return_ref(args)
    endif()


    package_dependency_parse(${ARGN})
    return_ans()
  endfunction()