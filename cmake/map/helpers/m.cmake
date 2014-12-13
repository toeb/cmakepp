
## function which generates a map 
## out of the passed args 
## or just returns the arg if it is already valid
function(m)
  
  set(args ${ARGN})
  # assignment
  list(LENGTH args len)
  if("${len}" GREATER 2)
    list(GET args 1 equal)
    list(GET args 0 target)
    if("${equal}" STREQUAL = AND "${target}" MATCHES "[a-zA-Z0-9_\\-]")
      list(REMOVE_AT args 0 )
      list(REMOVE_AT args 0 )
      m(${args})
      ans(res)
      set("${target}" "${res}" PARENT_SCOPE)
      return_ref(res)
    endif()
  endif()



  obj("${ARGN}")
  return_ans()
endfunction()

