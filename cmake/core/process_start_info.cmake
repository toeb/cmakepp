function(process_start_info obj)
  obj("${obj}")
  ans(obj)

  set(argn ${ARGN})

  set(path)
  set(cwd)
  set(command)
  set(args)
  set(parameters)
  set(timeout)
  scope_import_map(${obj})


  if("${args}_" STREQUAL "_")
    set(args ${parameters})
  endif()


  # now compile the command string
  set(arg_string)
  foreach(arg ${args})
    cmake_string_escape("${arg}")
    ans(arg)
    
    string_semicolon_decode("${arg}")
    ans(arg)      

    set(arg_string "${arg_string} \"${arg}\"")      
  endforeach()

  if("${command}_" STREQUAL "_")
    set(command "${path}")
    if("${command}_" STREQUAL "_")
      message(FATAL_ERROR "invalid <process start info> missing command property")
    endif()
  endif()

  if("${timeout}_" STREQUAL "_" )
    set(timeout -1)
  endif()




  path("${cwd}")
  ans(cwd)

  if(EXISTS "${cwd}")
    if(NOT IS_DIRECTORY "${cwd}")
      message(FATAL_ERROR "specified working directory path is a file not a directory: '${cwd}'")
    endif()
  else()
    message(FATAL_ERROR "specified workind directory path does not exist : '${cwd}'")
  endif()



  # create a map from the normalized input vars
  map_capture_new(command args arg_string cwd timeout)
  return_ans()

endfunction()