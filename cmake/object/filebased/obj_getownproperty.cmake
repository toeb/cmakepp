function(obj_getownproperty this result key)
	map_tryget("${this}" res "${key}")
	set("${result}" "${res}" PARENT_SCOPE)
endfunction()