function(obj_callmember this key)
	result_clear()
	#message(DEBUG LEVEL 10 "calling ${key} on ${this} with ${ARGN}")
	obj_nullcheck(${this})
	obj_get(${this} __func ${key})

	if(NOT __func)
		message(FATAL_ERROR "could not find function '${key}' from object '${this}'")
	endif()

	obj_loadcontext(${this})
	function_call(${__func}(${ARGN}))
endfunction()