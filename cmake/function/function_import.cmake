function(function_import callable)
  set(args ${ARGN})
  list_extract_flag(args REDEFINE)
  ans(redefine)
  list_extract_flag(args ONCE)
  ans(once)
  list_extract_labelled_value(args as)
  ans(function_name)

  if(callable STREQUAL "")
    message(FATAL_ERROR "no callable specified")
  endif()

  if(COMMAND "${function_name}" AND function_name AND "${function_name}" STREQUAL "${callable}")
    return_ref(function_name)
  endif()

  function_string_get("${callable}")
  ans(function_string)

  ## return the callables functions name  if it is a command
  ## and  if no newname was specified
  if(NOT function_name AND COMMAND "${callable}")
    return_ref(callable)
  endif()

  if(NOT function_name)
    function_new()
    ans(function_name)
    set(redefine true)
  endif()


  if(COMMAND "${function_name}" AND NOT redefine)
    if(once)
      return()
    endif()
    message(FATAL_ERROR "cannot import '${callable}' as '${function_name}' because it already exists")
  endif()

  function_string_rename("${function_string}" "${function_name}")
  ans(function_string)
  function_string_import("${function_string}")

  return_ref(function_name)
endfunction()