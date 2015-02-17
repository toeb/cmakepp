##
##
##
function(execute)
  arguments_encoded_list(${ARGC})
  ans(args)

  list_extract_flag(args --handle)
  ans(return_handle)
  list_extract_flag(args --exit-code)
  ans(return_exit_code)
  list_extract_flag(args --async)
  ans(async)
  list_extract_flag(args --async-wait)
  ans(wait)
  if(wait)
    set(async true)
  endif()
  list_extract_flag(args --silent-fail)
  ans(silent_fail)


  if(NOT args)
    messagE(FATAL_ERROR "no command specified")
  endif()

  process_start_info_new(${args})
  ans(start_info)

  process_handle_new(${start_info})
  ans(process_handle)


  if(async)
    process_start(${process_handle})
    return(${process_handle})
  else()
    process_execute(${process_handle})
    if(return_handle)
      return(${process_handle})
    endif()
    
    map_tryget(${process_handle} exit_code)
    ans(exit_code)

    if(return_exit_code)
      return_ref(exit_code)
    endif()

    map_tryget(${process_handle} pid)
    ans(pid)
    if(NOT pid)
      message(FATAL_ERROR FORMAT "could not find command '{start_info.command}'")
    endif()


    if(exit_code AND silent_fail)
      error("process {start_info.command} failed with {process_handle.exit_code}")
      return()
    endif()

    if(exit_code)
      message(FATAL_ERROR FORMAT "process {start_info.command} failed with {process_handle.exit_code}")
    endif()


    map_tryget(${process_handle} stdout)
    ans(stdout)
    return_ref(stdout)

  endif()


endfunction()