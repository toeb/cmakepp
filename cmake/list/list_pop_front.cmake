
function(list_pop_front  __list_pop_front_lst)
  set(res)

  list(LENGTH "${__list_pop_front_lst}" len)
  if("${len}" EQUAL 0)
    return()
  endif()

  list(GET ${__list_pop_front_lst} 0 res)

  if(${len} EQUAL 1) 
    set(${__list_pop_front_lst} )
  else()
    list(REMOVE_AT "${__list_pop_front_lst}" 0)
  endif()
  #message("${__list_pop_front_lst} is ${${__list_pop_front_lst}}")
#  set(${result} ${res} PARENT_SCOPE)
  set(${__list_pop_front_lst} ${${__list_pop_front_lst}} PARENT_SCOPE)
  return_ref(res)
endfunction()