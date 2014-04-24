function(obj_hasownproperty this result key)
	map_has("${this}" "${key}")
	return_value(${__ans})
endfunction()


