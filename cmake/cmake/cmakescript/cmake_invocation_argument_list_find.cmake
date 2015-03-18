## `(<begin: <cmake code>|<token>> <identifier:<regex>> [<regex>])-><any>...`
##
## returns the arguments for the specified invocation
## the optional regex can be used to check the argument list for a value
##
function(cmake_invocation_argument_list_find range identifier )
  set(regex ${ARGN})
  cmake_tokens("${range}")
  ans_extract(current_invocation)

  ans(rest)

  while(true)
    set(arguments)

    if(NOT current_invocation)
      break()  
    endif()

    cmake_token_range_find_invocations( "${current_invocation}" "${identifier}"  1)
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
