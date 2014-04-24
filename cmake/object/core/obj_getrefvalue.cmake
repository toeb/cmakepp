function(obj_getrefvalue this result)
	map_navigate(res ${this})
	set(${result} "${res}" PARENT_SCOPE)
endfunction()