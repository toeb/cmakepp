
function(map_print this)
	map_keys(${this} keys)
	foreach(key ${keys})
		map_get(${this}  value ${key})
		message("${key}: ${value}")
	endforeach()
endfunction()