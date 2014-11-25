# uses the selector on each element of the list
function(list_select __list_select_lst selector)
  list(LENGTH ${__list_select_lst} l)
  message(list_select ${l})
  set(__list_select_result_list)

  foreach(item ${${__list_select_lst}})
		rcall(res = "${selector}"("${item}"))
		list(APPEND __list_select_result_list ${res})

	endforeach()
  message("list_select end")
	return_ref(__list_select_result_list)
endfunction()
