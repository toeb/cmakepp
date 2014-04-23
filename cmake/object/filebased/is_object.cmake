# returns true if ref is an object
function(is_object result ref)
	obj_exists(${ref} _exists)
	if(NOT _exists)
		return_value(false)
	endif()
	ref_gettype(${ref})
	ans(res)
	return_value(${res})
	#if(IS_DIRECTORY "${ref}")
#		return_value(true)
#	else()
	#	return_value(false)
	#endif()
	
endfunction()

