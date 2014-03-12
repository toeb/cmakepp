# returns all values of the map which are passed as ARNG
function(map_values this result)
	set(res)
	foreach(arg ${ARGN})
		map_get(${this} val ${arg})
		list(APPEND res ${val})	
	endforeach()
	set(${result} ${res} PARENT_SCOPE)
endfunction()