## `(<begin: <cmake code>|<token>> <identifier:<regex>> [<regex>])-><any>...`
##
## returns the arguments for the specified invocation
## the optional regex can be used to check the argument list for a value
##
function(cmake_get_arguments_list begin identifier )
  set(regex ${ARGN})
  cmake_tokens("${begin}")
  ans_extract(current_invocation)
  ans(rest)

  while(true)
    set(arguments)

    if(NOT current_invocation)
      break()  
    endif()

    token_find_invocations("${identifier}" "${current_invocation}" "" 1)
    ans(current_invocation)
    if(NOT current_invocation)
      break()
    endiF()

    cmake_invocation_get_arguments_list("${current_invocation}")
    ans(arguments)

    if(NOT regex)
      break()
    endif()
    if("${arguments}" MATCHES "${regex}")
      break()
    endif()
    
    map_tryget(${current_invocation} next)
    ans(current_invocation)
  endwhile()
 return_ref(arguments)
endfunction()
