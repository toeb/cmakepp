function(map_values this result)
	
	foreach(arg ${ARGN})
		map_get(${this} val ${arg})
		list(APPEND res ${val})	
	endforeach()

	set(${result} ${res} PARENT_SCOPE)
endfunction()