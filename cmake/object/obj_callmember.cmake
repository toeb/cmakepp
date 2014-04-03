macro(obj_callmember this key)

	result_clear()
	message(DEBUG LEVEL 10 "calling ${key} on ${this} with ${ARGN}")
	obj_nullcheck(${this})

	# cannot pass func directly because it would be destroy inner
	# refferences to ${ARGN} because of the macro directives

	# create a temporary ref
	obj_get(${this} __func ${key})

	if(NOT __func)
		message(FATAL_ERROR "could not find function '${key}' from object '${this}'")
	endif()
	obj_pushcontext(${this})
	import_function("${__func}" as bound_function REDEFINE)
	bound_function(${ARGN})
	obj_popcontext()
endmacro()