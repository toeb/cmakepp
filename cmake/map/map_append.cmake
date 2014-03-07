# appends a value to the end of a map entry
function(map_append map key value)
	map_tryget(${map} existing_value ${key})
	if(NOT existing_value)
		map_set(${map} ${key} "${value}")
		return()
	endif()

	map_set(${map} ${key} "${existing_value};${value}")

endfunction()