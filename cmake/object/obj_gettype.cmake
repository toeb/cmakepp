function(obj_gettype this result)
	obj_getprototype(${this} proto)
	if(NOT proto)
		return_value("")
	endif()
	obj_getownproperty(${proto} res __init__)
	return_value(${res})

	
endfunction()