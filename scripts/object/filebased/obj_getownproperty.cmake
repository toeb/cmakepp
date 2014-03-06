function(obj_getownproperty this result key)
	#obj_getownref(${this} prop_ref ${key})
	#obj_getrefvalue(${prop_ref} res)
	
	map_tryget(${this} res ${key})
	set(${result} "${res}" PARENT_SCOPE)
	#return_value(${res})
endfunction()