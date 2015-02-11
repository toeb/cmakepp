function(test)
  ## create a test context
  map_new()
  ans(context)


  ## create a simple package which exports cmake files
  ## and register the on_load hook
  fwrite_data("pkg1/package.cmake" "{
    cmakepp:{
      hooks:{
        on_install:'cmake/on_install.cmake'
      }
    }
  }" --json)

  fwrite("pkg1/cmake/on_install.cmake" "
    ## function name is unimportant - it will be imported anyway
    function(__ a1 a2)
      map_set(${context} on_install_hook_called true \${a1} \${a2})
    endfunction()
  ")



  ## create project
  project_new()
  ans(proj)
  ## create package handle
  package_handle("pkg1")
  ans(pkg1)

  ## act
  timer_start(t1)
  event_emit(project_on_package_install ${proj} ${pkg1})
  timer_print_elapsed(t1)

  ## assert

  ## check that on_load hook was called
  assertf({context.on_install_hook_called} EQUALS true ${proj} ${pkg1})


  ## check that calling a project without the predefined fields does not fail
  fwrite_data("pkg2/package.cmake" "{

  }" --json)
  package_handle(pkg2)
  ans(pkg2)

  ## act
  event_emit(project_on_package_install ${proj} ${pkg2})

  ## no assertion success is when this code is reached :D





endfunction()