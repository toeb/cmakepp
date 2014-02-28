macro(obj_callmember this key)
	debug_message("calling ${key} on ${this} with ${ARGN}")
	obj_nullcheck(${this})
	obj_getref(${this} func ${key})

	if(NOT func)
		message(FATAL_ERROR "could not find function '${key}' from object '${this}'")
	endif()
	# maybe generate a unique name here?
	#message("funcy ${func}")
	#obj_get(${this} func2 ${key})
	#message("the func 2 ${func2}")
	#import_function(${func2} as obj_callmember_memberfunction REDEFINE)
	
	obj_bindcall(${this} "${func}" ${ARGN})
	#obj_callmember_memberfunction(${this} ${ARGN})

endmacro()