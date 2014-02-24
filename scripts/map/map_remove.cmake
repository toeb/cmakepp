


function(map_remove this key)
	map_check(${this})
	map_keys(${this} keys)
	list(FIND keys "${key}" res)
	if(${res} LESS 0)
		return()
	endif()
	list(REMOVE_AT ${this} ${res})
endfunction()