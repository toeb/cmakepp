function(test)

  ## i do not know if this is really on target.
  ## while it is nice to have extensiosn that can easily be registered
  ## and unregistered I am not convinced that this might not be needless
  ## repitition...  so for now this will be on hold
  return()

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

    map_tryget(${extension} on_register)
    ans(on_register)
    if(on_register)
      call2("${on_register}" ${project} ${extension})
    endif()

    log("project extension registered: {extension_name}" --function project_extension_register)
    event_emit(project_on_extension_registered ${project_handle} ${extension})

    return_ref(extension)
  endfunction()


  ## 
  ##
  ## removes the extension specified by extension_name from the project
  ## 
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
    
    map_tryget(${extension} on_unregister)
    ans(on_unregister)
    if(on_unregister)
      call2("${on_unregister}" ${project} ${extension})
    endif()
    event_emit(project_on_extension_unregistered ${project} ${extension})

    return(${extension})
  endfunction()

  ## `(<project handle>)-><project extension>`
  ##
  ## ```
  ## <project extension> ::= {
  ##     extension_name: <string> # unique string that identifies this extension
  ##     on_register: <callable:<(<project handle> <extension>)-><void>>  ## callaback which is invoked when the extension is registered
  ##     on_unregister: <callable:<(<project handle> <extension>)-><void>> ## callback which is invoked when the extension is unregistered
  ## }
  ## ```
  ##
  ## creates a project extension from the specified input
  ## scope: project_handle
  ##
  function(project_extension project_handle)
    value(${ARGN})
    ans(extension)
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
    functioN(test_extension_register project extension)

    endfunction()
    
    functioN(test_extension_register project extension)

    endfunction()
    set(args ${ARGN})
    ## if no arg is passed the extension is created and returned
    if(NOT args)
      map_new()
      ans(extension)
      map_set(${extension} extension_name "my_test_extension")
      map_set(${extension} on_register test_extension_register)
      map_set(${extension} on_unregister test_extension_unregister)
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




  project_extension_unregister("${project}" "my_test_extension")
  ans(extension)
  assert(extension)

  assertf({tracker.project_on_extension_unregistered.args[0]} STREQUAL "${project}")
  assertf({tracker.project_on_extension_unregistered.args[1]} STREQUAL "${extension}")
  assertf("{project.project_descriptor.project_extensions.my_test_extension}" ISNULL)


endfunction()