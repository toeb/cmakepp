#returns the prop_ref for obj[key] or notfound (if object itself has the property)
function(obj_getownref this result key)
	obj_hasownproperty(${this} _hasprop ${key})
	if(NOT _hasprop)
		return_value(NOTFOUND)
	endif()

	return_value("${this}.${key}")
endfunction()