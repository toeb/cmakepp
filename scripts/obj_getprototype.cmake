function(obj_getprototype this result)
	obj_getownproperty(${this} proto __proto__)
	return_value(${proto})
endfunction()