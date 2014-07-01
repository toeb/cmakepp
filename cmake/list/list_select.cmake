# uses the selector on each element of the list
function(list_select __list_select_lst selector)
  set(__list_select_result_list)
  foreach(item ${${__list_select_lst}})
		rcall(res = "${selector}"("${item}"))
		list(APPEND __list_select_result_list ${res})
	endforeach()
	return_ref(__list_select_result_list)
endfunction()
