function(function_import)
  cmake_parse_arguments("" "REDEFINE;ONCE" "as" "" ${ARGN})
  #_UNPARSED_ARGUMENTS
  if(NOT _UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "function_import: missing function to import")
  endif()


  list(LENGTH _UNPARSED_ARGUMENTS arg_count)

  if(${arg_count} LESS 1)  
    message(FATAL_ERROR "invalid usage of function_import")
  endif()

  list(GET _UNPARSED_ARGUMENTS 0 _import_function_func)
  set(function_name ${_as})


  if(function_name AND "_${function_name}" STREQUAL "${_import_function_func}"  )
    # cmake function already exists.
    message(DEBUG LEVEL 6 "function '${function_name}' should be imported as '${_as}' ... returning without operation")
    return()
  endif()
  # get function implementation this fails if _import_function_func is not a function

  get_function_string(function_string "${_import_function_func}")
 

  function_parse(_import_function_func "${function_string}")
  ans(func_info)


  map_tryget("${func_info}" name)
  ans(func_name)

  if(NOT function_name)
    map_tryget("${func_info}" name)
    ans(function_name)
  endif()


  # code which is run everytime a function is called
  if(inject_debug_info OR true)
    set(on_call 
    "set(imported_caller_function_name ${imported_function_name})
    set(imported_function_name ${function_name})")
  endif()
  


  if(COMMAND "${function_name}" AND NOT _REDEFINE)
    if(_ONCE)
      message(DEBUG LEVEL 6 "returning because '${function_name}' was already imported")
      return()
    endif()
    message(FATAL_ERROR "cannot import ${function_name} because it already exists")
  endif()



  function_string_rename(function_string  "${function_string}" "${function_name}")
  function_string_import("${function_string}")
endfunction()