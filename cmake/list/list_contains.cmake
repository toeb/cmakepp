# returns true if __list_contains_lst contains every element of ARGN 
function(list_contains __list_contains_lst)
	foreach(arg ${ARGN})
		list(FIND ${__list_contains_lst} "${arg}" idx)
		if(${idx} LESS 0)
			return(false)
		endif()
	endforeach()
	return(true)
endfunction()

function(list_is_superset_of __list_is_superset_lstA __lst_is_superset_lstB)
  list(REMOVE_ITEM ${__lst_is_superset_lstB} ${__list_is_superset_lstA})
  list(LENGTH __lst_is_superset_lstB len)
  if(len)
    return(false)
  endif()
  return(true)
endfunction()


function(list_contains_all __list_contains_all_lst)
  set(args ${ARGN})
  list_is_superset_of(__list_contains_all_lst args)
  return_ans()

endfunction()
