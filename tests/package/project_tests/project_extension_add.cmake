function(test)

  function(project_extension_register project_handle extension)
    project_extension("${project_handle}" "${extension}")
    ans(extension)
    if(NOT extension)
      error("tried to register invalid extension" --function project_extension_register)
      return()
    endif()
    map_tryget(${extension} extension_name)
    ans(extension_name)
    map_tryget(${project_handle} project_descriptor)
    ans(project_descriptor)
    map_get_map(${project_descriptor} project_extensions)
    ans(project_extensions)


    map_tryget(${project_extensions} "${extension_name}")
    ans(existing_extension)

    if(existing_extension)
      error("extension '{extension_name}' is already registered" --function project_extension_register)
      return()
    endif()

    map_set(${project_extensions} "${extension_name}" "${extension}")
    
    ## register events in correct order
    assign(back_listener_map = extension.back_listeners)
    assign(front_listener_map = extension.front_listeners)

    map_keys("${back_listener_map}")
    ans(back_listeners)
    map_keys("${front_listener_map}")
    ans(front_listeners)
    foreach(front_listener ${front_listeners})
      map_tryget(${front_listener_map} "${front_listener}")
      ans(handler)
      event_addhandler(${front_listener} "${handler}")
    endforeach()
    foreach(back_listener ${back_listeners})
      map_tryget(${back_listener_map} "${back_listener}")
      ans(handler)
      event_addhandler(${back_listener} ${handler})
    endforeach()
    log("project extension registered: {extension_name}" --function project_extension_register)
    event_emit(project_on_extension_registered ${project_handle} ${extension})

    return_ref(extension)
  endfunction()

  function(project_extension_unregister project_handle extension_name)
    assign(extensions = "project_handle.project_descriptor.project_extensions")
    if(NOT extensions)
      return()
    endif()
    map_tryget("${extensions}" "${extension_name}")
    ans(extension)
    if(NOT extension)
      error("extension {extension_name} does not exist" --function project_extension_unregister )
      return()
    endif()
    log("project extension unregistered: {extension_name}" --function project_extension_unregister)
    map_remove("${extensions}" "${extension_name}")
    event_emit(project_on_extension_unregistered ${project} ${extension})
  endfunction()

  ## scope: project_handle
  function(project_extension project_handle)
    value(${ARGN})
    ans(extension)
    print_vars(extension)
    is_address("${extension}")
    ans(is_ref)

    if(NOT is_ref)
      return()
    endif()
    map_tryget(${extension} extension_name)
    ans(extension_name)
    if("${extension_name}_" STREQUAL "_")
      return()
    endif()
    return_ref(extension)
  endfunction()



  function(test_extension)
    set(args ${ARGN})
    ## if no arg is passed the extension is created and returned
    if(NOT args)
      map_new()
      ans(extension)
      map_set(${extension} extension_name "my_test_extension")
      assign(!extension.back_listeners.project_on_open = 'test_extension')
      return_ref(extension)
    endif()

    list_extract(args project)

    map_tryget(${project} open_count)
    ans(counter)
    if(NOT counter)
      set(counter 0)
    endif()
    math(EXPR counter "${counter} + 1")
    map_set(${project} open_count ${counter})
    return()
  endfunction()

  project_open(.)
  ans(project)

  events_track(project_on_extension_registered project_on_extension_unregistered)
  ans(tracker)

  project_extension_register("${project}" test_extension)
  ans(extension)


  assertf("{tracker.project_on_extension_registered.args[0]}" STREQUAL "${project}")
  assertf("{tracker.project_on_extension_registered.args[1]}" STREQUAL "${extension}")
  assertf("{project.project_descriptor.project_extensions.my_test_extension}" STREQUAL "${extension}")

  project_close(${project})

  project_open(. "${project}")
  ans(project)
  assertf("{project.open_count}" EQUAL 1)

  project_close(${project})
  project_open(. ${project})
  assertf("{project.open_count}" EQUAL 2)




endfunction()