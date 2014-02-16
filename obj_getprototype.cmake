function(obj_getprototype ref result)
	obj_getownproperty(${ref} proto __proto__)
	return_value(${proto})
endfunction()