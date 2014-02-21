macro(obj_callmember this key)
	debug_message("calling ${key} on ${this} with ${ARGN}")
	obj_nullcheck(${this})
	obj_getref(${this} func ${key})
	import_function(${func} as obj_callmember_memberfunction REDEFINE)

	obj_callmember_memberfunction(${this} ${ARGN})

endmacro()