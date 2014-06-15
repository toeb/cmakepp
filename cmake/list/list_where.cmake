# executes a predicate on every item of the list (passed by reference)
# and returns those items for which the predicate holds
function(list_where __list_where_lst predicate)
	foreach(item ${${__list_where_lst}})
    rcall(__matched = "${predicate}"("${item}"))
		if(__matched)
			list(APPEND result_list ${item})
		endif()
	endforeach()
	return_ref(result_list)
endfunction()


