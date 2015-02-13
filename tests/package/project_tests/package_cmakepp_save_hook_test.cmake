function(test)


  map_new()
  ans(context)
  
  set(on_save_hook "[](a b)map_append(${context} hook_called {{a}} {{b}})")

  fwrite_data("pkg1/package.cmake" "{
    cmakepp:{
      hooks:{
        on_save:$on_save_hook
      }
    }
  }" --json)


  project_new()
  ans(proj)
  package_handle("pkg1")
  ans(pkg1)

  timer_start(t1)
  event_emit(project_on_package_save ${proj} ${pkg1})
  timer_print_elapsed(t1)


  assertf("{context.hook_called[0]}" STREQUAL "${proj}")
  assertf("{context.hook_called[1]}" STREQUAL "${pkg1}")



  ## no hook defined

  map_new()
  ans(context)
  
  set(on_save_hook "[](a b)map_append(${context} hook_called {{a}} {{b}})")

  fwrite_data("pkg1/package.cmake" "{
    cmakepp:{
      hooks:{
      }
    }
  }" --json)


  project_new()
  ans(proj)
  package_handle("pkg1")
  ans(pkg1)

  timer_start(t1)
  event_emit(project_on_package_save ${proj} ${pkg1})
  timer_print_elapsed(t1)







endfunction()