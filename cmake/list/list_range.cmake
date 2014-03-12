
#retruns the specified range of lst if length is less than 0
# it will count the index from the back (listlength - length)
function(list_range result lst start_index length)		

	if(${length} LESS 0)
		list(LENGTH ${lst} len)
		math(EXPR end_index "${len} ${length}")
	else()
		math(EXPR end_index "${start_index} + ${length}")
	endif()
	set(res)
	foreach(i RANGE ${start_index} ${end_index})
		list(GET ${lst} ${i} val)
		set(res ${res} "${val}")
	endforeach()
	set(${result} ${res} PARENT_SCOPE)
endfunction()