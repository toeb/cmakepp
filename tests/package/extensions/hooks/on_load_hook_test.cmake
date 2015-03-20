function(test)
  ## create a test context
  map_new()
  ans(context)


  ## create a simple package which exports cmake files
  ## and register the on_load hook
  fwrite_data("pkg1/package.cmake" "{
    cmake:{
      export:['cmake/**.cmake', '!cmake/pkg1_func3.cmake']
    },
    hooks:{
      on_load:'[](a1 a2) map_set(${context} on_load_called true {{a1}} {{a2}})'
    }
  
  }" --json)
  fwrite("pkg1/cmake/pkg1_func1.cmake" "
    function(pkg1_func1)
      return(func1call)
    endfunction()
  ")
  fwrite("pkg1/cmake/pkg1_func2.cmake" "
    function(pkg1_func2)
      return(func2call)
    endfunction()
  ")
  fwrite("pkg1/cmake/pkg1_func3.cmake" "
    function(pkg1_func3)
      return(func3call)
    endfunction()
  ")



  ## create project
  map_new()
  ans(proj)

  ## create package handle
  package_handle("pkg1")
  ans(pkg1)


  ## act
  timer_start(t1)
  event_emit(project_on_package_loaded ${proj} ${pkg1})
  timer_print_elapsed(t1)

  ## assert

  ## check that exported functions were loaded 
  assert(COMMAND pkg1_func1)
  assert(COMMAND pkg1_func1)
  assert(NOT COMMAND pkg1_func3)
  ## check that the functions are correclty callable
  assign(res = pkg1_func1())
  assert("${res}" STREQUAL "func1call")
  assign(res = pkg1_func2())
  assert("${res}" STREQUAL "func2call")
  ## check that on_load hook was called
  assertf({context.on_load_called} EQUALS true ${proj} ${pkg1})



  ## check that calling a project without the predefined fields does not fail
  fwrite_data("pkg2/package.cmake" "{

  }" --json)
  package_handle(pkg2)
  ans(pkg2)

  ## act
  event_emit(project_on_package_loaded ${proj} ${pkg2})

  ## no assertion





endfunction()