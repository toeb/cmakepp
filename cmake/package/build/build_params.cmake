
 parameter_definition(build_params
    [--generator:<string>]
    [--config:<string>]
    [--linkage:<string>]
    [--release]
    [--debug]
    [--shared]
    [--static]
    
    )
  function(build_params)
    arguments_extract_defined_values(0 ${ARGC} build_params)    
    ans(args)



    log("generating build params")
    if(NOT generator)
      is_script_mode()
      ans(isScriptMode)
      if(isScriptMode)
        cmake_environment()
        ans(env)
        assign(generator = env.cmake.default_generator)
      else()
        set(generator "${CMAKE_GENERATOR}")
      endif()
      
    endif()    



    if(release)
      set(config release)
    endif()
    if(debug)
      set(config debug)
    endif()

    if(shared)
      set(linkage shared)
    endif()
    if(static)
      set(linkage static)
    endif()

    if(NOT linkage)
      ## prefer shared linkage
      if(DEFINED BUILD_SHARED_LIBS)
        if(BUILD_SHARED_LIBS)
          set(linkage shared)
        else()
          set(linkage static)
        endif()
      else()
        set(linkage *)
      endif()
    endif()

    if(NOT config)
      if(DEFINED CMAKE_BUILD_TYPE)
        if(CMAKE_BUILD_TYPE)
          set(config "${CMAKE_BUILD_TYPE}")
        else()
        endif()
      else()
        set(config *)
      endif()
      
    endif()

    string_tolower("${config}")
    ans(config)

    cmake_build_environment("${generator}" ${args})
    ans(param)

    map_set(${param} config ${config})
    map_set(${param} linkage ${linkage})

    return(${param})

  endfunction()