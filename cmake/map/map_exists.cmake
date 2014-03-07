
function(map_exists this result)
	get_property(keys GLOBAL PROPERTY "${this}")
	if(keys)
		return_value(true)
	else()
		return_value(false)
	endif()
endfunction()