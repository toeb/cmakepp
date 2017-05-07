
 parameter_definition(build_params
    [--generator:<string>]
    [--config:<string>]
    [--release]
    [--debug]
    
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

    if(NOT config)
      set(config release)
    endif()

    string_tolower("${config}")
    ans(config)

    cmake_build_environment("${generator}" ${args})
    ans(param)

    map_set(${param} config ${config})

    log("config is {config}")
    log("generator is {generator}")
    log("build param is {param}")

    return(${param})

  endfunction()