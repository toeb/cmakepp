function(obj_gettype this result)
	obj_get(${this} constructor __ctor__)
	if(NOT constructor)
		return_value(NOTFOUND)
	endif()

	obj_get(${constructor} call __call__)
	if(NOT call)
		return_value(NOTFOUND)
	endif()
	
	parse_function(func "${call}")
	return_value("${func_name}")
	
  #obj_getownproperty(${this} type "__type__")
  #return_value(${type})
endfunction()