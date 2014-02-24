function(obj_get this result key)
	obj_getref(${this} prop_ref ${key})
	if(NOT prop_ref)
		return_value(NOTFOUND)
	endif()
	obj_getrefvalue(${prop_ref} value)
	# just to make sure value is not evaluated too much
	
	set(${result} "${value}" PARENT_SCOPE)
	
endfunction()